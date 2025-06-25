# MiddleClick

A macOS app that converts three-finger trackpad clicks to middle clicks, perfect for closing browser tabs and other middle-click actions.

[![GitHub](https://img.shields.io/badge/GitHub-Repository-blue.svg)](https://github.com/WinkyTy/MacOS-Trackpad-MiddleClick.git)

## Features

- **Background Operation**: Runs silently in the background with a menu bar icon
- **Three-Finger Detection**: Detects three-finger trackpad gestures and converts them to middle clicks
- **Easy Control**: Simple menu bar interface to enable/disable the feature
- **Permission Management**: Automatic handling of accessibility permissions
- **Cross-Application Support**: Works with any application that supports middle clicks

## Requirements

- macOS 10.15 (Catalina) or later
- Built-in trackpad or Magic Trackpad
- Xcode 12.0 or later (for building from source)
- Accessibility permissions (granted automatically on first run)

## Installation

### Option 1: Build from Source (Recommended)

1. **Clone the repository:**
   ```bash
   git clone https://github.com/WinkyTy/MacOS-Trackpad-MiddleClick.git
   cd MacOS-Trackpad-MiddleClick
   ```

2. **Open in Xcode:**
   ```bash
   open MiddleClick.xcodeproj
   ```

3. **Build the project:**
   - In Xcode, press `⌘+B` to build
   - Or use the build script: `./build.sh`

4. **Run the app:**
   - In Xcode, press `⌘+R` to run
   - Or run from command line: `open build/Release/MiddleClick.app`

### Option 2: Using the Build Script

1. **Clone and build:**
   ```bash
   git clone https://github.com/WinkyTy/MacOS-Trackpad-MiddleClick.git
   cd MacOS-Trackpad-MiddleClick
   chmod +x build.sh
   ./build.sh
   ```

### Option 3: Manual Build

1. **Clone the repository:**
   ```bash
   git clone https://github.com/WinkyTy/MacOS-Trackpad-MiddleClick.git
   cd MacOS-Trackpad-MiddleClick
   ```

2. **Build using xcodebuild:**
   ```bash
   xcodebuild -project MiddleClick.xcodeproj -scheme MiddleClick -configuration Release
   ```

3. **Run the app:**
   ```bash
   open build/Release/MiddleClick.app
   ```

## First Run Setup

### 1. Launch the App
After building, launch the MiddleClick app. You'll see a grid icon appear in your menu bar.

### 2. Grant Accessibility Permissions
When you first run the app, you'll be prompted to grant accessibility permissions:

1. **Click "Open System Preferences"** when prompted
2. **Navigate to:** System Preferences > Security & Privacy > Privacy > Accessibility
3. **Add MiddleClick** to the list:
   - Click the lock icon to make changes
   - Click the "+" button
   - Navigate to your app location and select MiddleClick
   - Check the box next to MiddleClick
4. **Restart the app** if needed

### 3. Enable the Feature
1. **Click the grid icon** in your menu bar
2. **Select "Enable Middle Click"** from the menu
3. **Verify the icon is filled** (indicating the feature is active)

## Usage

### Menu Bar Interface

The app appears as a grid icon in your menu bar:

- **🟦 Filled Grid Icon**: Feature is enabled and active
- **⚪ Outline Grid Icon**: Feature is disabled

### Menu Options

- **Enable/Disable Middle Click**: Toggle the three-finger to middle-click conversion
- **Status**: Shows current status (Enabled/Disabled)
- **About MiddleClick**: Information about the app
- **Open System Preferences**: Quick access to accessibility settings
- **Quit**: Exit the application

### How to Use

1. **Ensure the feature is enabled** (filled grid icon in menu bar)
2. **Perform a three-finger click** on your trackpad
3. The app will **convert it to a middle click** at the same location
4. **Perfect for:**
   - Closing browser tabs
   - Opening links in new tabs
   - Other middle-click actions in any application

### Testing the App

1. **Open a web browser** (Chrome, Safari, Firefox)
2. **Open multiple tabs**
3. **Enable MiddleClick** from the menu bar
4. **Try a three-finger click** on a tab
5. **The tab should close** (middle-click behavior)

## Troubleshooting

### App Not Working

1. **Check Permissions:**
   - System Preferences > Security & Privacy > Privacy > Accessibility
   - Ensure MiddleClick is checked and enabled

2. **Restart the App:**
   - Quit MiddleClick from the menu bar
   - Relaunch the application

3. **Check Menu Bar Status:**
   - Ensure the feature is enabled (filled grid icon)
   - Check the status in the menu

### Three-Finger Gestures Not Detected

1. **Verify Trackpad Settings:**
   - System Preferences > Trackpad
   - Ensure "Tap to click" and other gestures are enabled

2. **Try Different Gestures:**
   - Three-finger click (press down)
   - Three-finger tap (light tap)
   - Three-finger swipe

3. **Check App Status:**
   - Ensure MiddleClick is enabled in the menu bar
   - Verify accessibility permissions are granted

### Middle Clicks Not Working in Some Apps

- **Application Limitations**: Some applications may not respond to programmatically generated middle clicks
- **Browser Compatibility**: Works best with modern browsers (Chrome, Safari, Firefox, Edge)
- **System Apps**: May have limited support in some system applications

### Build Issues

1. **Xcode Version:**
   - Ensure you have Xcode 12.0 or later
   - Update Xcode if needed

2. **Build Errors:**
   - Clean the project: `Product > Clean Build Folder` in Xcode
   - Delete derived data: `Window > Projects > Click arrow next to project > Delete`

3. **Permission Issues:**
   - Ensure you have admin privileges
   - Check that the project is in a writable location

## Development

### Project Structure

```
MiddleClick/
├── MiddleClick/
│   ├── MiddleClickApp.swift      # Main app delegate
│   ├── StatusBarController.swift # Menu bar interface
│   ├── TrackpadHandler.swift     # Gesture detection
│   ├── ContentView.swift         # Unused (background app)
│   └── Info.plist               # App configuration
├── MiddleClickTests/            # Unit tests
├── MiddleClickUITests/          # UI tests
├── build.sh                     # Build script
└── README.md                    # This file
```

### Key Components

1. **Event Monitoring**: Uses NSEvent monitors to detect trackpad gestures
2. **CGEvent Tap**: Alternative method for intercepting mouse events
3. **Accessibility Integration**: Proper permission handling and status checking
4. **Background Operation**: Runs as a menu bar app without dock icon

### Building for Distribution

1. **Archive the project** in Xcode:
   - Product > Archive
   - Select "Distribute App"
   - Choose "Copy App"

2. **Create DMG** (optional):
   - Use Disk Utility to create a disk image
   - Drag the app to the disk image
   - Eject and distribute

### Contributing

1. **Fork the repository**
2. **Create a feature branch**: `git checkout -b feature-name`
3. **Make your changes**
4. **Test thoroughly**
5. **Submit a pull request**

## License

This project is open source. Feel free to modify and distribute according to your needs.

## Support

If you encounter any issues:

1. **Check the troubleshooting section** above
2. **Open an issue** on GitHub with:
   - macOS version
   - Xcode version
   - Detailed error description
   - Steps to reproduce

## Changelog

### Version 1.0
- Initial release
- Three-finger to middle-click conversion
- Menu bar interface
- Accessibility permission handling
- Background operation

---

**Enjoy using MiddleClick!** 🖱️✨ 