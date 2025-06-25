//
//  MiddleClickApp.swift
//  MiddleClick
//
//  Created by Tyler Fynch on 25/06/2025.
//

import SwiftUI
import AppKit

@main
struct MiddleClickApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBarController: StatusBarController?
    var trackpadHandler: TrackpadHandler?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Hide dock icon
        NSApp.setActivationPolicy(.accessory)
        
        // Initialize status bar
        statusBarController = StatusBarController()
        
        // Initialize trackpad handler
        trackpadHandler = TrackpadHandler()
        trackpadHandler?.statusBarController = statusBarController
        statusBarController?.trackpadHandler = trackpadHandler
        
        // Start NSEvent monitoring as backup
        trackpadHandler?.startNSEventMonitoring()
        
        // Request accessibility permissions
        requestAccessibilityPermissions()
    }
    
    private func requestAccessibilityPermissions() {
        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue(): true]
        let accessEnabled = AXIsProcessTrustedWithOptions(options as CFDictionary)
        
        if !accessEnabled {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                let alert = NSAlert()
                alert.messageText = "Accessibility Permission Required"
                alert.informativeText = "This app needs accessibility permissions to detect trackpad gestures and simulate middle clicks. Please grant permission in System Preferences > Security & Privacy > Privacy > Accessibility."
                alert.alertStyle = .warning
                alert.addButton(withTitle: "Open System Preferences")
                alert.addButton(withTitle: "OK")
                
                let response = alert.runModal()
                if response == .alertFirstButtonReturn {
                    NSWorkspace.shared.open(URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")!)
                }
            }
        }
    }
}
