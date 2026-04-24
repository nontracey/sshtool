FROM cirrusci/flutter:stable

WORKDIR /app

# Copy project files
COPY pubspec.yaml .
COPY pubspec.lock* .
COPY lib/ lib/
COPY android/ android/
COPY assets/ assets/
COPY test/ test/

# Get dependencies
RUN flutter pub get

# Build release APK
RUN flutter build apk --release --shrink

# Build app bundle
RUN flutter build appbundle --release

# Output will be in:
# /app/build/app/outputs/flutter-apk/app-release.apk
# /app/build/app/outputs/bundle/release/app-release.aab
