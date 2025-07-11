class Middleclick < Formula
  desc "macOS app that converts three-finger trackpad clicks to middle clicks"
  homepage "https://github.com/WinkyTy/MacOS-Trackpad-MiddleClick"
  url "https://github.com/WinkyTy/MacOS-Trackpad-MiddleClick/archive/refs/heads/main.tar.gz"
  sha256 "2b07d2327cfbb64d59587f0b993614dc79b56ce83b5e055e4396f0ebcff253b0"
  version "1.0.0"
  license "MIT"
  head "https://github.com/WinkyTy/MacOS-Trackpad-MiddleClick.git", branch: "main"

  depends_on :xcode => ["12.0", :build]
  depends_on :macos

  def install
    # Build the app
    system "xcodebuild", "-project", "MiddleClick.xcodeproj", 
                        "-scheme", "MiddleClick", 
                        "-configuration", "Release", 
                        "SYMROOT=build"
    
    # Install the app to the Applications folder
    prefix.install "build/Release/MiddleClick.app"
    
    # Create a symlink in bin for easy access
    bin.install_symlink prefix/"MiddleClick.app/Contents/MacOS/MiddleClick"
  end

  def caveats
    <<~EOS
      MiddleClick has been installed to your Applications folder.
      
      To complete setup:
      1. Open MiddleClick from Applications
      2. Grant accessibility permissions when prompted
      3. Enable the feature from the menu bar
      
      For more information, visit: #{homepage}
    EOS
  end

  test do
    # Check if the app was built successfully
    assert_predicate prefix/"MiddleClick.app", :exist?
  end
end 