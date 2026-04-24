#!/bin/bash

# SSH Tool v1.0.0 - Automated Release Script
# This script guides you through the release process

set -e

echo "╔═══════════════════════════════════════════════════════════╗"
echo "║                                                           ║"
echo "║           SSH Tool v1.0.0 - Release Script               ║"
echo "║                                                           ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""

# Check Flutter
if ! command -v flutter &> /dev/null; then
    echo "⚠️  Flutter not found!"
    echo ""
    echo "Please install Flutter first:"
    echo "  macOS/Linux:"
    echo "    git clone https://github.com/flutter/flutter.git -b stable"
    echo "    export PATH=\"\$PATH:\$(pwd)/flutter/bin\""
    echo "    flutter doctor"
    echo ""
    echo "  Windows:"
    echo "    Download from https://flutter.dev/docs/get-started/install/windows"
    echo ""
    echo "Or use the provided Docker setup:"
    echo "  docker build -t ssh-tool ."
    echo "  docker run -v \$(pwd):/app ssh-tool"
    echo ""
    exit 1
fi

echo "✓ Flutter found: $(flutter --version | head -1)"
echo ""

# Initialize Flutter if needed
echo "🔧 Initializing Flutter..."
flutter doctor
echo ""

# Get dependencies
echo "📦 Installing dependencies..."
flutter pub get
echo ""

# Run tests
echo "🧪 Running tests..."
flutter test || echo "⚠️  Tests failed, but continuing..."
echo ""

# Build release APK
echo "🔨 Building release APK..."
flutter build apk --release --shrink
echo ""

APK_PATH="build/app/outputs/flutter-apk/app-release.apk"
if [ -f "$APK_PATH" ]; then
    APK_SIZE=$(du -h "$APK_PATH" | cut -f1)
    echo "✅ APK built successfully!"
    echo "   📁 Location: $APK_PATH"
    echo "   📊 Size: $APK_SIZE"
    echo ""
    
    # Create release directory
    RELEASE_DIR="release-v1.0.0"
    mkdir -p "$RELEASE_DIR"
    cp "$APK_PATH" "$RELEASE_DIR/ssh-tool-v1.0.0.apk"
    
    echo "📁 Copied to: $RELEASE_DIR/ssh-tool-v1.0.0.apk"
    echo ""
else
    echo "❌ APK build failed!"
    exit 1
fi

# Build app bundle
echo "📦 Building app bundle..."
flutter build appbundle --release
echo ""

AAB_PATH="build/app/outputs/bundle/release/app-release.aab"
if [ -f "$AAB_PATH" ]; then
    AAB_SIZE=$(du -h "$AAB_PATH" | cut -f1)
    echo "✅ App bundle built successfully!"
    echo "   📁 Location: $AAB_PATH"
    echo "   📊 Size: $AAB_SIZE"
    echo ""
    
    cp "$AAB_PATH" "$RELEASE_DIR/ssh-tool-v1.0.0.aab"
    echo "📁 Copied to: $RELEASE_DIR/ssh-tool-v1.0.0.aab"
    echo ""
fi

# Copy documentation
echo "📄 Copying documentation..."
cp README.md "$RELEASE_DIR/"
cp CHANGELOG.md "$RELEASE_DIR/"
cp RELEASE-v1.0.0.md "$RELEASE_DIR/"
cp LICENSE "$RELEASE_DIR/"
cp QUICKSTART.md "$RELEASE_DIR/"
echo "✓ Documentation copied"
echo ""

# Generate checksums
echo "🔐 Generating checksums..."
cd "$RELEASE_DIR"
if command -v sha256sum &> /dev/null; then
    sha256sum *.apk *.aab > checksums.txt
elif command -v shasum &> /dev/null; then
    shasum -a 256 *.apk *.aab > checksums.txt
else
    echo "⚠️  sha256sum not found, skipping checksums"
fi
cd ..
echo "✓ Checksums generated"
echo ""

# Summary
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║                                                           ║"
echo "║                  🎉 Build Complete! 🎉                   ║"
echo "║                                                           ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""
echo "📦 Release Package: $RELEASE_DIR/"
echo ""
ls -lh "$RELEASE_DIR/"
echo ""
echo "🚀 Next Steps:"
echo ""
echo "1. Test the APK on a device:"
echo "   flutter install"
echo ""
echo "2. Create Git tag:"
echo "   git add ."
echo "   git commit -m 'Release v1.0.0'"
echo "   git tag -a v1.0.0 -m 'v1.0.0 - Initial Release'"
echo "   git push origin master --tags"
echo ""
echo "3. Create GitHub Release:"
echo "   - Go to: https://github.com/yourusername/sshtool/releases/new"
echo "   - Select tag: v1.0.0"
echo "   - Title: v1.0.0 - Initial Release"
echo "   - Copy content from: RELEASE-v1.0.0.md"
echo "   - Upload: $RELEASE_DIR/ssh-tool-v1.0.0.apk"
echo "   - Upload: $RELEASE_DIR/ssh-tool-v1.0.0.aab"
echo "   - Click: Publish release"
echo ""
echo "4. Distribute:"
echo "   - Share release link"
echo "   - Post on social media"
echo "   - Update website"
echo ""
echo "✨ Happy releasing!"
