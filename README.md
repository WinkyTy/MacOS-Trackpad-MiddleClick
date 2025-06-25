# MiddleClick

A macOS app that converts three-finger trackpad clicks to middle clicks, perfect for closing browser tabs and other middle-click actions.

## Features

- **Background Operation**: Runs silently in the background with a menu bar icon
- **Three-Finger Detection**: Detects three-finger trackpad gestures and converts them to middle clicks
- **Easy Control**: Simple menu bar interface to enable/disable the feature
- **Permission Management**: Automatic handling of accessibility permissions

## Requirements

- macOS 10.15 (Catalina) or later
- Built-in trackpad or Magic Trackpad
- Accessibility permissions (granted automatically on first run)

## Installation

### Building from Source

1. Open the project in Xcode:
   ```bash
   cd "xCode/xcode Projects/MiddleClick"
   open MiddleClick.xcodeproj
   ```

2. Select your target device (Mac) and build the project (⌘+B)

3. Run the app (⌘+R) or archive it for distribution

### First Run Setup

1. Launch the MiddleClick app
2. When prompted, grant accessibility permissions:
   - Click "Open System Preferences"
   - Navigate to Security & Privacy > Privacy > Accessibility
   - Add MiddleClick to the list and check the box
   - Restart the app if needed

## Usage

### Menu Bar Controls

The app appears as a grid icon in your menu bar:

- **Filled Grid Icon**: Feature is enabled
- **Outline Grid Icon**: Feature is disabled

### Menu Options

- **Enable/Disable Middle Click**: Toggle the three-finger to middle-click conversion
- **Status**: Shows current status (Enabled/Disabled)
- **About MiddleClick**: Information about the app
- **Open System Preferences**: Quick access to accessibility settings
- **Quit**: Exit the application

### How It Works

1. **Enable the feature** from the menu bar
2. **Perform a three-finger click** on your trackpad
3. The app will **convert it to a middle click** at the same location
4. Perfect for **closing browser tabs** and other middle-click actions

## Troubleshooting

### App Not Working

1. **Check Permissions**: Ensure MiddleClick has accessibility permissions
   - System Preferences > Security & Privacy > Privacy > Accessibility
   - Make sure MiddleClick is checked

2. **Restart the App**: Quit and relaunch MiddleClick

3. **Check Menu Bar**: Ensure the feature is enabled (filled grid icon)

### Three-Finger Gestures Not Detected

- Make sure you're using a **three-finger click** (not tap)
- Try different trackpad sensitivity settings
- Ensure the app is enabled in the menu bar

### Middle Clicks Not Working in Some Apps

- Some applications may not respond to programmatically generated middle clicks
- This is a limitation of the target application, not MiddleClick

## Development

### Project Structure

- `MiddleClickApp.swift`: Main app delegate and initialization
- `StatusBarController.swift`: Menu bar interface and controls
- `TrackpadHandler.swift`: Core gesture detection and middle-click simulation
- `ContentView.swift`: Unused in background mode (kept for compatibility)

### Key Components

1. **Event Monitoring**: Uses NSEvent monitors to detect trackpad gestures
2. **CGEvent Tap**: Alternative method for intercepting mouse events
3. **Accessibility Integration**: Proper permission handling and status checking
4. **Background Operation**: Runs as a menu bar app without dock icon

### Building for Distribution

1. Archive the project in Xcode
2. Export as a macOS Application
3. The app will run in the background and appear in the menu bar

## License

This project is open source. Feel free to modify and distribute according to your needs.

## Contributing

Contributions are welcome! Please feel free to submit pull requests or open issues for bugs and feature requests. 