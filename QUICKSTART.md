# Quick Start Guide

## Prerequisites

1. Install Flutter SDK (3.0 or higher)
   ```bash
   # macOS/Linux
   git clone https://github.com/flutter/flutter.git -b stable
   export PATH="$PATH:`pwd`/flutter/bin"
   flutter doctor
   
   # Windows - Download from https://flutter.dev/docs/get-started/install/windows
   ```

2. Install Android Studio or VS Code with Flutter extension

## Installation Steps

1. Navigate to project directory:
   ```bash
   cd sshtool
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app in debug mode:
   ```bash
   flutter run
   ```

## Build Release APK

### Standard Build (8-12 MB)
```bash
flutter build apk --release
```

### Optimized Build (Smaller Size)
```bash
flutter build apk --release --target-platform android-arm64 --shrink
```

### App Bundle (For Play Store)
```bash
flutter build appbundle --release
```

## Project Structure

```
sshtool/
├── lib/
│   ├── main.dart              # App entry point
│   ├── models/                # Data models (SshHost, AppSettings)
│   ├── providers/             # State management (Riverpod)
│   ├── screens/               # UI screens
│   │   ├── host_list_screen.dart
│   │   ├── terminal_screen.dart
│   │   └── settings_screen.dart
│   ├── services/              # Business logic
│   │   ├── ssh_service.dart
│   │   └── storage_service.dart
│   ├── theme/                 # Theming
│   ├── utils/                 # Utilities
│   └── widgets/               # Reusable components
├── android/                   # Android configuration
├── pubspec.yaml              # Dependencies
└── README.md                 # Documentation
```

## Features

### 1. SSH Host Management
- Add/Edit/Delete hosts
- Group organization
- Quick connection
- Connection history

### 2. SSH Terminal
- Full PTY support
- Password & SSH key auth
- Command history
- Keyboard shortcuts

### 3. Settings
- Theme: Light/Dark/System
- 10 color schemes
- Custom fonts
- Terminal customization

## Keyboard Shortcuts

| Key | Action |
|-----|--------|
| Enter | Send command |
| Tab | Auto-complete |
| Esc | Cancel |
| ↑/↓ | History navigation |
| Ctrl+C | Interrupt |
| Ctrl+D | EOF |
| Ctrl+Z | Suspend |

## Performance Tips

1. **Reduce APK Size**
   - Use `--shrink` flag
   - Remove unused dependencies
   - Optimize images

2. **Improve Performance**
   - Use release mode for testing
   - Enable ProGuard
   - Use const widgets

3. **Battery Optimization**
   - Disable keep screen on when not needed
   - Use connection timeout

## Troubleshooting

### Flutter not found
```bash
export PATH="$PATH:/path/to/flutter/bin"
```

### Build errors
```bash
flutter clean
flutter pub get
flutter build apk
```

### Permission denied
```bash
chmod +x android/gradlew
```

## Next Steps

1. Add your SSH hosts
2. Customize settings
3. Start connecting!

## Support

For issues and feature requests, please create an issue on GitHub.
