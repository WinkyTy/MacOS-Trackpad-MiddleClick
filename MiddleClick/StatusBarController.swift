//
//  StatusBarController.swift
//  MiddleClick
//
//  Created by AI Assistant on 25/06/2025.
//

import AppKit

class StatusBarController: NSObject {
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    private let menu = NSMenu()
    private var featureEnabled = false {
        didSet {
            updateMenu()
            updateStatusIcon()
        }
    }
    weak var trackpadHandler: TrackpadHandler?

    override init() {
        super.init()
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "circle.grid.3x3.fill", accessibilityDescription: "MiddleClick")
        }
        constructMenu()
    }

    private func constructMenu() {
        let toggleItem = NSMenuItem(title: "Enable Middle Click", action: #selector(toggleFeature), keyEquivalent: "")
        toggleItem.state = featureEnabled ? .on : .off
        toggleItem.target = self
        menu.addItem(toggleItem)
        
        menu.addItem(NSMenuItem.separator())
        
        let statusItem = NSMenuItem(title: "Status: Disabled", action: nil, keyEquivalent: "")
        statusItem.isEnabled = false
        menu.addItem(statusItem)
        
        menu.addItem(NSMenuItem.separator())
        
        let aboutItem = NSMenuItem(title: "About MiddleClick", action: #selector(showAbout), keyEquivalent: "")
        aboutItem.target = self
        menu.addItem(aboutItem)
        
        let preferencesItem = NSMenuItem(title: "Open System Preferences", action: #selector(openSystemPreferences), keyEquivalent: "")
        preferencesItem.target = self
        menu.addItem(preferencesItem)
        
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quit), keyEquivalent: "q"))
        menu.items.forEach { $0.target = self }
        statusItem.menu = menu
    }

    private func updateMenu() {
        if let toggleItem = menu.items.first {
            toggleItem.state = featureEnabled ? .on : .off
            toggleItem.title = featureEnabled ? "Disable Middle Click" : "Enable Middle Click"
        }
        
        // Update status item
        if menu.items.count > 3 {
            let statusItem = menu.items[3]
            if featureEnabled {
                statusItem.title = "Status: Enabled"
            } else {
                statusItem.title = "Status: Disabled"
            }
        }
    }
    
    private func updateStatusIcon() {
        if let button = statusItem.button {
            if featureEnabled {
                button.image = NSImage(systemSymbolName: "circle.grid.3x3.fill", accessibilityDescription: "MiddleClick Enabled")
                button.image?.isTemplate = false
            } else {
                button.image = NSImage(systemSymbolName: "circle.grid.3x3", accessibilityDescription: "MiddleClick Disabled")
                button.image?.isTemplate = true
            }
        }
    }

    @objc private func toggleFeature() {
        featureEnabled.toggle()
        
        // Check accessibility permissions when enabling
        if featureEnabled && !AXIsProcessTrusted() {
            let alert = NSAlert()
            alert.messageText = "Accessibility Permission Required"
            alert.informativeText = "This app needs accessibility permissions to detect trackpad gestures and simulate middle clicks. Please grant permission in System Preferences > Security & Privacy > Privacy > Accessibility."
            alert.alertStyle = .warning
            alert.addButton(withTitle: "Open System Preferences")
            alert.addButton(withTitle: "Cancel")
            
            let response = alert.runModal()
            if response == .alertFirstButtonReturn {
                openSystemPreferences()
            } else {
                // Revert the toggle if user cancels
                featureEnabled = false
            }
        }
    }
    
    @objc private func showAbout() {
        let alert = NSAlert()
        alert.messageText = "MiddleClick"
        alert.informativeText = "A macOS app that converts three-finger trackpad clicks to middle clicks.\n\nPerfect for closing browser tabs and other middle-click actions."
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
    
    @objc private func openSystemPreferences() {
        NSWorkspace.shared.open(URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")!)
    }

    @objc private func quit() {
        NSApp.terminate(nil)
    }

    // Expose featureEnabled for logic in AppDelegate or elsewhere.
    func isFeatureEnabled() -> Bool {
        return featureEnabled && AXIsProcessTrusted()
    }
}
