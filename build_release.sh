#!/bin/bash

# SSH Tool Build Script
# This script builds the release APK for distribution

set -e

echo "🚀 Building SSH Tool v1.0.0..."
echo ""

# Check Flutter installation
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter not found. Please install Flutter first."
    exit 1
fi

echo "✓ Flutter found: $(flutter --version | head -1)"
echo ""

# Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean
echo ""

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get
echo ""

# Run tests (optional)
# echo "🧪 Running tests..."
# flutter test
# echo ""

# Build release APK
echo "🔨 Building release APK..."
flutter build apk --release --shrink
echo ""

# Build app bundle (for Play Store)
echo "📦 Building app bundle..."
flutter build appbundle --release
echo ""

# Show build info
echo "✅ Build completed successfully!"
echo ""
echo "📱 APK Location: build/app/outputs/flutter-apk/app-release.apk"
echo "📦 Bundle Location: build/app/outputs/bundle/release/app-release.aab"
echo ""

# Get file sizes
APK_SIZE=$(du -h build/app/outputs/flutter-apk/app-release.apk | cut -f1)
AAB_SIZE=$(du -h build/app/outputs/bundle/release/app-release.aab | cut -f1)

echo "📊 Build sizes:"
echo "   APK: $APK_SIZE"
echo "   Bundle: $AAB_SIZE"
echo ""

# Optional: Create a release directory
RELEASE_DIR="release-v1.0.0"
mkdir -p "$RELEASE_DIR"
cp build/app/outputs/flutter-apk/app-release.apk "$RELEASE_DIR/ssh-tool-v1.0.0.apk"
cp build/app/outputs/bundle/release/app-release.aab "$RELEASE_DIR/ssh-tool-v1.0.0.aab"
cp RELEASE-v1.0.0.md "$RELEASE_DIR/"
cp CHANGELOG.md "$RELEASE_DIR/"
cp README.md "$RELEASE_DIR/"

echo "📁 Release files copied to: $RELEASE_DIR/"
echo ""
echo "🎉 Ready for distribution!"
