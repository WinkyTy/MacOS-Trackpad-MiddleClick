//
//  TrackpadHandler.swift
//  MiddleClick
//
//  Created by AI Assistant on 25/06/2025.
//

import AppKit
import Carbon

class TrackpadHandler: NSObject {
    weak var statusBarController: StatusBarController?
    private var eventTap: CFMachPort?
    private var runLoopSource: CFRunLoopSource?
    private var globalMonitor: Any?
    private var localMonitor: Any?
    private var lastThreeFingerTime: TimeInterval = 0
    private let threeFingerThreshold: TimeInterval = 0.3 // seconds
    private var isThreeFingerActive = false
    
    override init() {
        super.init()
        setupEventMonitoring()
    }
    
    deinit {
        if let eventTap = eventTap {
            CGEvent.tapEnable(tap: eventTap, enable: false)
        }
        if let globalMonitor = globalMonitor {
            NSEvent.removeMonitor(globalMonitor)
        }
        if let localMonitor = localMonitor {
            NSEvent.removeMonitor(localMonitor)
        }
    }
    
    private func setupEventMonitoring() {
        // Set up global event monitoring for gestures
        globalMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.gesture, .magnify, .rotate, .swipe]) { [weak self] event in
            self?.handleGestureEvent(event)
        }
        
        // Set up local event monitoring for more detailed trackpad events
        localMonitor = NSEvent.addLocalMonitorForEvents(matching: [.gesture, .magnify, .rotate, .swipe]) { [weak self] event in
            return self?.handleLocalGestureEvent(event) ?? event
        }
        
        // Also set up CGEvent tap for mouse events
        setupEventTap()
    }
    
    private func setupEventTap() {
        let eventMask = (1 << CGEventType.nsOtherMouseDown.rawValue) |
                       (1 << CGEventType.nsOtherMouseUp.rawValue) |
                       (1 << CGEventType.tapDisabledByTimeout.rawValue) |
                       (1 << CGEventType.tapDisabledByUserInput.rawValue)
        
        eventTap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: CGEventMask(eventMask),
            callback: { (proxy, type, event, refcon) -> Unmanaged<CGEvent>? in
                let handler = Unmanaged<TrackpadHandler>.fromOpaque(refcon!).takeUnretainedValue()
                return handler.handleEvent(proxy: proxy, type: type, event: event)
            },
            userInfo: Unmanaged.passUnretained(self).toOpaque()
        )
        
        if let eventTap = eventTap {
            runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
            if let runLoopSource = runLoopSource {
                CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
                CGEvent.tapEnable(tap: eventTap, enable: true)
            }
        }
    }
    
    private func handleGestureEvent(_ event: NSEvent) {
        guard statusBarController?.isFeatureEnabled() == true else { return }
        
        switch event.type {
        case .gesture:
            handleGesture(event)
        case .magnify:
            // Magnify gesture might indicate three-finger interaction
            if event.magnification > 0.1 {
                // This could be part of a three-finger gesture
            }
        case .rotate:
            // Rotation gesture might indicate three-finger interaction
            if abs(event.rotation) > 0.1 {
                // This could be part of a three-finger gesture
            }
        case .swipe:
            // Swipe gesture with three fingers
            if event.phase == .began {
                let currentTime = event.timestamp
                if currentTime - lastThreeFingerTime < threeFingerThreshold {
                    // This might be a three-finger click
                    simulateMiddleClick(at: event.locationInWindow)
                }
                lastThreeFingerTime = currentTime
            }
        default:
            break
        }
    }
    
    private func handleLocalGestureEvent(_ event: NSEvent) -> NSEvent? {
        guard statusBarController?.isFeatureEnabled() == true else { return event }
        
        // Check for three-finger click gesture
        if event.type == .gesture {
            if let result = handleGesture(event) {
                return result
            }
        }
        
        return event
    }
    
    private func handleGesture(_ event: NSEvent) -> NSEvent? {
        let phase = event.phase
        let gestureMask = event.gestureMask
        
        // Check for three-finger click
        if gestureMask.contains(.click) {
            if phase == .began {
                // This is likely a three-finger click
                simulateMiddleClick(at: event.locationInWindow)
                return nil // Consume the event
            }
        }
        
        // Check for three-finger tap (alternative to click)
        if gestureMask.contains(.pressure) {
            if phase == .began {
                // This might be a three-finger tap
                simulateMiddleClick(at: event.locationInWindow)
                return nil // Consume the event
            }
        }
        
        return event
    }
    
    private func handleEvent(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent) -> Unmanaged<CGEvent>? {
        // Check if the feature is enabled
        guard statusBarController?.isFeatureEnabled() == true else {
            return Unmanaged.passUnretained(event)
        }
        
        // Check if we have accessibility permissions
        guard AXIsProcessTrusted() else {
            return Unmanaged.passUnretained(event)
        }
        
        switch type {
        case .nsOtherMouseDown, .nsOtherMouseUp:
            // This is a trackpad event, let's check if it's a three-finger click
            if isThreeFingerClick(event: event) {
                // Convert to middle click
                return convertToMiddleClick(event: event, type: type)
            }
        case .tapDisabledByTimeout, .tapDisabledByUserInput:
            // Re-enable the tap if it gets disabled
            DispatchQueue.main.async {
                if let eventTap = self.eventTap {
                    CGEvent.tapEnable(tap: eventTap, enable: true)
                }
            }
        default:
            break
        }
        
        return Unmanaged.passUnretained(event)
    }
    
    private func isThreeFingerClick(event: CGEvent) -> Bool {
        // Get the event data to check for three-finger gesture
        let data = event.data1
        let flags = event.flags
        
        // Check for three-finger gesture flags
        // This is a simplified approach - in practice, you might need to use
        // NSEvent or other APIs to get more detailed trackpad information
        let threeFingerMask: UInt64 = 0x8000000000000000 // Simplified mask for three-finger
        
        if (data & threeFingerMask) != 0 {
            let currentTime = event.timestamp
            if currentTime - lastThreeFingerTime < threeFingerThreshold {
                lastThreeFingerTime = currentTime
                return true
            }
            lastThreeFingerTime = currentTime
        }
        
        return false
    }
    
    private func convertToMiddleClick(event: CGEvent, type: CGEventType) -> Unmanaged<CGEvent>? {
        let location = event.location
        let flags = event.flags
        
        // Create a new middle click event
        let middleClickEvent: CGEvent?
        
        switch type {
        case .nsOtherMouseDown:
            middleClickEvent = CGEvent(mouseEventSource: nil, mouseType: .otherMouseDown, mouseCursorPosition: location, mouseButton: .center)
        case .nsOtherMouseUp:
            middleClickEvent = CGEvent(mouseEventSource: nil, mouseType: .otherMouseUp, mouseCursorPosition: location, mouseButton: .center)
        default:
            return Unmanaged.passUnretained(event)
        }
        
        if let middleClickEvent = middleClickEvent {
            // Copy relevant flags from the original event
            middleClickEvent.flags = flags
            
            // Post the middle click event
            middleClickEvent.post(tap: .cghidEventTap)
            
            // Return nil to prevent the original event from being processed
            return nil
        }
        
        return Unmanaged.passUnretained(event)
    }
    
    // Alternative approach using NSEvent monitoring
    func startNSEventMonitoring() {
        // This is now handled in setupEventMonitoring()
    }
    
    private func simulateMiddleClick(at location: NSPoint) {
        let screenLocation = NSEvent.mouseLocation
        
        // Create and post middle mouse down event
        let mouseDown = CGEvent(mouseEventSource: nil, mouseType: .otherMouseDown, mouseCursorPosition: screenLocation, mouseButton: .center)
        mouseDown?.post(tap: .cghidEventTap)
        
        // Small delay to simulate real click
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            // Create and post middle mouse up event
            let mouseUp = CGEvent(mouseEventSource: nil, mouseType: .otherMouseUp, mouseCursorPosition: screenLocation, mouseButton: .center)
            mouseUp?.post(tap: .cghidEventTap)
        }
    }
} 