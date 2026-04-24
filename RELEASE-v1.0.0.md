# Release v1.0.0 - Initial Release

## SSH Tool - Android SSH Manager

A powerful, lightweight SSH client for Android built with Flutter.

### Download

- **APK**: [ssh-tool-v1.0.0.apk](https://github.com/yourusername/sshtool/releases/download/v1.0.0/ssh-tool-v1.0.0.apk)
- **Size**: ~10MB
- **Platform**: Android 5.0+ (API 21+)

---

## Features

### 🖥️ SSH Host Management
- ✅ Add, edit, delete, and duplicate SSH hosts
- ✅ Organize hosts by groups
- ✅ Quick connection with one tap
- ✅ Connection history and statistics
- ✅ Color-coded hosts for easy identification

### 🔌 SSH Terminal
- ✅ Full PTY terminal support
- ✅ Password and SSH key authentication
- ✅ Real-time output display
- ✅ Command history navigation
- ✅ Hardware keyboard support
- ✅ Quick action buttons (ESC, TAB, arrows)
- ✅ Auto-scroll with lock option

### ⚙️ Settings & Customization
- ✅ **Themes**: Light, Dark, System default
- ✅ **Colors**: 10 beautiful color schemes
- ✅ **UI Fonts**: Multiple font options
- ✅ **Terminal Fonts**: Monospace fonts optimized for code
- ✅ **Font Size**: Adjustable 8-32sp
- ✅ **Line Height**: Customizable spacing
- ✅ **Cursor Style**: Block, Underline, or Bar
- ✅ **Behavior**: Screen on, bell sound, vibration
- ✅ **Advanced**: Scrollback, timeout settings

### 🎨 UI/UX
- ✅ Material Design 3
- ✅ Smooth 60fps animations
- ✅ Responsive for all screen sizes
- ✅ Tablet and phone optimized
- ✅ Portrait and landscape support

---

## Technical Details

### Performance
- **APK Size**: 8-15MB (optimized)
- **Startup**: Fast initialization
- **Memory**: Efficient resource usage
- **Battery**: Optimized for low power consumption

### Compatibility
- Android 5.0+ (Lollipop)
- ARM and ARM64 architectures
- Android 14 (API 34) tested

### Security
- Secure credential storage
- SSH key support
- No analytics or tracking
- No internet permissions beyond SSH

---

## Installation

### Method 1: Direct APK Install
1. Download the APK from the link above
2. Enable "Install from unknown sources" in Android settings
3. Open the APK and install
4. Launch SSH Tool and add your first host!

### Method 2: Build from Source
```bash
git clone https://github.com/yourusername/sshtool.git
cd sshtool
flutter pub get
flutter build apk --release
```

---

## Quick Start

1. **Add a Host**
   - Tap the + button
   - Enter host details (name, address, username, password)
   - Choose a color for easy identification
   - Save

2. **Connect**
   - Tap on the host card
   - Wait for connection
   - Start typing commands!

3. **Customize**
   - Go to Settings (⚙️ icon)
   - Choose your theme and colors
   - Adjust terminal font and size
   - Configure behavior options

---

## Keyboard Shortcuts

| Key | Action |
|-----|--------|
| Enter | Send command |
| Tab | Auto-complete |
| Esc | Cancel/Exit |
| ↑ | Previous command |
| ↓ | Next command |
| ←/→ | Move cursor |
| Ctrl+C | Interrupt |
| Ctrl+D | End of file |
| Ctrl+Z | Suspend |

---

## Screenshots

### Host List Screen
- Clean card-based layout
- Group filtering
- Search functionality
- Quick actions menu

### Terminal Screen
- Full-screen terminal
- Status bar with connection info
- Quick action buttons
- Command input with history

### Settings Screen
- Organized sections
- Color picker
- Font selector
- Slider controls

---

## Known Issues

- None reported in this release

---

## What's Next?

### Coming in v1.1.0
- SFTP file transfer
- SSH key generation
- Snippet management
- Export/Import hosts

### Planned for v1.2.0
- Port forwarding
- Multi-tab sessions
- Cloud sync
- Biometric unlock

---

## Contributing

Found a bug? Have a feature request?

1. Check existing issues
2. Create a new issue with details
3. Submit a pull request

---

## License

MIT License - Free for personal and commercial use

---

## Credits

Built with:
- [Flutter](https://flutter.dev/) - UI framework
- [dartssh2](https://github.com/TerminalStudio/dartssh2) - SSH library
- [Riverpod](https://riverpod.dev/) - State management
- [Hive](https://docs.hivedb.dev/) - Data persistence
- [FlexColorScheme](https://rydmike.com/flexcolorscheme/) - Theming

Inspired by:
- [Termius](https://termius.com/)
- [uTerm](https://github.com/uterm)

---

## Support

- **Issues**: [GitHub Issues](https://github.com/yourusername/sshtool/issues)
- **Discussions**: [GitHub Discussions](https://github.com/yourusername/sshtool/discussions)
- **Email**: your.email@example.com

---

**Enjoy using SSH Tool!** 🚀

If you find this app useful, please consider:
- ⭐ Starring the repository
- 📢 Sharing with others
- 🐛 Reporting bugs
- 💡 Suggesting features
