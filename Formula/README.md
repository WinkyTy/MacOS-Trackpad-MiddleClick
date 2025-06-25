# Homebrew Formula for MiddleClick

This directory contains the Homebrew formula for installing MiddleClick via `brew install`.

## Installation Options

### Option 1: Install from Homebrew Tap (Recommended)

1. **Add the tap:**
   ```bash
   brew tap WinkyTy/middleclick
   ```

2. **Install MiddleClick:**
   ```bash
   brew install middleclick
   ```

### Option 2: Install from Local Formula

1. **Clone the repository:**
   ```bash
   git clone https://github.com/WinkyTy/MacOS-Trackpad-MiddleClick.git
   cd MacOS-Trackpad-MiddleClick
   ```

2. **Install using the local formula:**
   ```bash
   brew install --build-from-source Formula/middleclick.rb
   ```

### Option 3: Install from GitHub URL

```bash
brew install --build-from-source https://raw.githubusercontent.com/WinkyTy/MacOS-Trackpad-MiddleClick/main/Formula/middleclick.rb
```

## Setting Up Your Own Tap

To make your app available via `brew install`, you have two options:

### Option A: Create a Homebrew Tap Repository

1. **Create a new repository** named `homebrew-tap` (or `homebrew-<yourname>`)
2. **Add the formula** to the repository
3. **Users can install** with:
   ```bash
   brew tap yourusername/tap
   brew install middleclick
   ```

### Option B: Submit to Homebrew Core

1. **Fork the homebrew-core repository**
2. **Add your formula** to `Formula/middleclick.rb`
3. **Submit a pull request**
4. **Once accepted**, users can install with:
   ```bash
   brew install middleclick
   ```

## Formula Details

The formula:
- **Builds from source** using Xcode
- **Installs to Applications folder**
- **Creates a symlink** for command-line access
- **Includes setup instructions** in caveats
- **Requires macOS** and Xcode 12.0+

## Testing the Formula

```bash
# Test locally
brew install --build-from-source Formula/middleclick.rb

# Test with verbose output
brew install --build-from-source --verbose Formula/middleclick.rb

# Uninstall
brew uninstall middleclick
```

## Updating the Formula

When you release a new version:

1. **Run the release script:**
   ```bash
   ./scripts/create-release.sh 1.0.1 "Bug fixes and improvements"
   ```

2. **Update the formula** with the new version and SHA256

3. **Commit and push** the changes

4. **Create a GitHub release** with the generated archive

## Troubleshooting

### Build Issues
- Ensure Xcode is installed and up to date
- Check that the project builds locally first
- Verify all dependencies are available

### Installation Issues
- Check Homebrew is up to date: `brew update`
- Try installing with verbose output for more details
- Ensure you have write permissions to `/usr/local` or `/opt/homebrew`

### Permission Issues
- The app requires accessibility permissions after installation
- Follow the caveats instructions to complete setup 