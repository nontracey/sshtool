.PHONY: all clean build build-debug build-release test run install help

all: build

clean:
	@echo "🧹 Cleaning..."
	flutter clean

deps:
	@echo "📦 Getting dependencies..."
	flutter pub get

build-debug: deps
	@echo "🔨 Building debug APK..."
	flutter build apk --debug

build-release: deps
	@echo "🚀 Building release APK..."
	flutter build apk --release --shrink

build-bundle: deps
	@echo "📦 Building app bundle..."
	flutter build appbundle --release

build: build-release

test:
	@echo "🧪 Running tests..."
	flutter test

run:
	@echo "▶️  Running app..."
	flutter run

run-release:
	@echo "▶️  Running release mode..."
	flutter run --release

install:
	@echo "📱 Installing on device..."
	flutter install

doctor:
	@echo "🏥 Running Flutter doctor..."
	flutter doctor

format:
	@echo "✨ Formatting code..."
	dart format lib/

analyze:
	@echo "🔍 Analyzing code..."
	flutter analyze

release: clean build-release build-bundle
	@echo "✅ Release build complete!"
	@ls -lh build/app/outputs/flutter-apk/app-release.apk
	@ls -lh build/app/outputs/bundle/release/app-release.aab

help:
	@echo "SSH Tool - Build Commands"
	@echo ""
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  all            Build release APK (default)"
	@echo "  clean          Clean build artifacts"
	@echo "  deps           Get dependencies"
	@echo "  build-debug    Build debug APK"
	@echo "  build-release  Build release APK"
	@echo "  build-bundle   Build app bundle (AAB)"
	@echo "  build          Build release APK"
	@echo "  test           Run tests"
	@echo "  run            Run app in debug mode"
	@echo "  run-release    Run app in release mode"
	@echo "  install        Install on connected device"
	@echo "  doctor         Run Flutter doctor"
	@echo "  format         Format code"
	@echo "  analyze        Analyze code"
	@echo "  release        Full release build"
	@echo "  help           Show this help message"
	@echo ""
	@echo "Examples:"
	@echo "  make build-debug"
	@echo "  make run"
	@echo "  make release"
