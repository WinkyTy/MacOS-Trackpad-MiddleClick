#!/bin/bash

# MiddleClick Build Script
# This script helps build and run the MiddleClick app

echo "Building MiddleClick..."

# Check if Xcode is installed
if ! command -v xcodebuild &> /dev/null; then
    echo "Error: Xcode is not installed or not in PATH"
    exit 1
fi

# Navigate to project directory
cd "$(dirname "$0")"

# Clean previous builds
echo "Cleaning previous builds..."
xcodebuild clean -project MiddleClick.xcodeproj -scheme MiddleClick

# Build the project
echo "Building project..."
xcodebuild build -project MiddleClick.xcodeproj -scheme MiddleClick -configuration Release

if [ $? -eq 0 ]; then
    echo "Build successful!"
    echo ""
    echo "To run the app:"
    echo "1. Open Xcode"
    echo "2. Open MiddleClick.xcodeproj"
    echo "3. Press Cmd+R to run"
    echo ""
    echo "Or run directly from command line:"
    echo "open build/Release/MiddleClick.app"
else
    echo "Build failed!"
    exit 1
fi 