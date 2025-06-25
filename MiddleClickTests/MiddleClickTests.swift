//
//  MiddleClickTests.swift
//  MiddleClickTests
//
//  Created by Tyler Fynch on 25/06/2025.
//

import Testing
import AppKit
@testable import MiddleClick

struct MiddleClickTests {

    @Test func testStatusBarControllerInitialization() async throws {
        let controller = StatusBarController()
        #expect(controller.isFeatureEnabled() == false)
    }
    
    @Test func testTrackpadHandlerInitialization() async throws {
        let handler = TrackpadHandler()
        #expect(handler != nil)
    }
    
    @Test func testAccessibilityPermissions() async throws {
        // This test checks if we can detect accessibility permissions
        // Note: This will always return false in test environment
        let hasAccess = AXIsProcessTrusted()
        #expect(hasAccess == false) // Should be false in test environment
    }
    
    @Test func testAppDelegateInitialization() async throws {
        let appDelegate = AppDelegate()
        #expect(appDelegate.statusBarController == nil) // Not initialized yet
        #expect(appDelegate.trackpadHandler == nil) // Not initialized yet
    }
    
    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
        #expect(true) // Basic test to ensure testing framework works
    }

}
