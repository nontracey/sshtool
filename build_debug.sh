#!/bin/bash

# Quick build script for development and testing

set -e

echo "🔨 Building SSH Tool (Debug)..."
flutter build apk --debug

if [ $? -eq 0 ]; then
    echo "✅ Debug APK built successfully!"
    echo "📱 Location: build/app/outputs/flutter-apk/app-debug.apk"
    ls -lh build/app/outputs/flutter-apk/app-debug.apk
else
    echo "❌ Build failed!"
    exit 1
fi
