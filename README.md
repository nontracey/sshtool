# SSH Tool - Android SSH Manager

A powerful, lightweight SSH client for Android built with Flutter.

## Features

### 🖥️ SSH Host Management
- Add, edit, delete, and duplicate SSH hosts
- Organize hosts by groups
- Quick connection with one tap
- Connection history and statistics

### 🔌 SSH Connection
- Full terminal support with PTY
- Support for password and SSH key authentication
- Real-time output display
- Custom keyboard shortcuts (ESC, TAB, arrows, etc.)

### ⚙️ Settings & Customization
- **Theme**: Light, Dark, or System default
- **Theme Colors**: 10 beautiful color schemes
- **UI Fonts**: Multiple font options
- **Terminal Fonts**: Monospace fonts optimized for code
- **Terminal Font Size**: Adjustable from 8-32sp
- **Line Height**: Customizable line spacing
- **Cursor Style**: Block, Underline, or Bar
- **Behavior**: Keep screen on, bell sound, vibration
- **Advanced**: Scrollback lines, connection timeout

### 🎨 UI/UX
- Material Design 3
- Smooth animations and transitions
- Responsive layout for all screen sizes
- Support for hardware keyboards
- Optimized for performance

## Tech Stack

- **Framework**: Flutter 3.x
- **Language**: Dart
- **State Management**: Riverpod
- **Database**: Hive (NoSQL)
- **SSH Library**: dartssh2
- **UI**: Material Design 3 with FlexColorScheme

## Installation

### Prerequisites
- Flutter SDK 3.0 or higher
- Android Studio / VS Code
- Android SDK (minSdkVersion 21)

### Build & Run

1. Clone the repository:
```bash
git clone <repository-url>
cd sshtool
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

4. Build release APK:
```bash
flutter build apk --release
```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── ssh_host.dart        # SSH host model
│   └── app_settings.dart    # Settings model
├── providers/               # State management
│   ├── hosts_provider.dart  # Hosts state
│   └── settings_provider.dart
├── screens/                 # UI screens
│   ├── host_list_screen.dart
│   ├── terminal_screen.dart
│   └── settings_screen.dart
├── services/                # Business logic
│   ├── ssh_service.dart     # SSH connection
│   └── storage_service.dart # Data persistence
├── theme/                   # Theming
│   ├── app_theme.dart
│   └── terminal_colors.dart
└── widgets/                 # Reusable widgets
```

## Performance Optimizations

- **Small APK Size**: 8-15MB with ProGuard and resource shrinking
- **Fast Startup**: Lazy loading and optimized initialization
- **Smooth UI**: 60fps animations with Flutter's Skia rendering
- **Efficient State**: Riverpod for minimal rebuilds
- **Fast Database**: Hive for quick data access

## Keyboard Shortcuts

| Key | Action |
|-----|--------|
| Enter | Send command |
| Tab | Auto-complete |
| Esc | Cancel/Exit |
| ↑/↓ | Command history |
| ←/→ | Cursor movement |
| Home/End | Line start/end |

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

MIT License - feel free to use this project for personal or commercial purposes.

## Inspiration

This project is inspired by:
- [Termius](https://termius.com/) - Cross-platform SSH client
- [uTerm](https://github.com/uterm) - Android terminal emulator

## Roadmap

- [ ] SFTP file transfer support
- [ ] SSH key generation
- [ ] Port forwarding
- [ ] Snippets/Command templates
- [ ] Multi-session tabs
- [ ] Cloud sync
- [ ] Biometric authentication
