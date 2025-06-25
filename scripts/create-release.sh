#!/bin/bash

# Script to create a GitHub release and update Homebrew formula
# Usage: ./scripts/create-release.sh <version> <release_notes>

set -e

VERSION=$1
RELEASE_NOTES=$2

if [ -z "$VERSION" ]; then
    echo "Usage: $0 <version> [release_notes]"
    echo "Example: $0 1.0.0 'Initial release'"
    exit 1
fi

if [ -z "$RELEASE_NOTES" ]; then
    RELEASE_NOTES="Release $VERSION"
fi

echo "Creating release v$VERSION..."

# Create a git tag
git tag -a "v$VERSION" -m "Release v$VERSION"

# Push the tag to GitHub
git push origin "v$VERSION"

# Create a release archive
ARCHIVE_NAME="MiddleClick-v$VERSION.tar.gz"
git archive --format=tar.gz --prefix="MacOS-Trackpad-MiddleClick-$VERSION/" "v$VERSION" > "$ARCHIVE_NAME"

# Calculate SHA256
SHA256=$(shasum -a 256 "$ARCHIVE_NAME" | cut -d' ' -f1)

echo "Archive created: $ARCHIVE_NAME"
echo "SHA256: $SHA256"

# Update the formula with the correct SHA256
sed -i.bak "s/PLACEHOLDER_SHA256/$SHA256/g" Formula/middleclick.rb
sed -i.bak "s/v1.0.0/v$VERSION/g" Formula/middleclick.rb

echo "Updated Formula/middleclick.rb with SHA256: $SHA256"

# Create a temporary formula for testing
cp Formula/middleclick.rb Formula/middleclick-test.rb

echo ""
echo "Release preparation complete!"
echo ""
echo "Next steps:"
echo "1. Go to https://github.com/WinkyTy/MacOS-Trackpad-MiddleClick/releases"
echo "2. Create a new release with tag v$VERSION"
echo "3. Upload the archive: $ARCHIVE_NAME"
echo "4. Add release notes: $RELEASE_NOTES"
echo ""
echo "To test the formula locally:"
echo "brew install --build-from-source Formula/middleclick-test.rb"
echo ""
echo "To submit to Homebrew core (optional):"
echo "1. Fork homebrew-core repository"
echo "2. Add the formula to Formula/middleclick.rb"
echo "3. Submit a pull request" 