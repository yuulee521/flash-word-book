# Flash Word Book

A cross-platform Flutter dictionary app that helps you build your personal vocabulary directly from your clipboard.

## Features

- **Clipboard Integration**: Instantly split copied sentences into selectable words.
- **Auto-Lookup**: Fetches meanings and phonetics automatically from the Free Dictionary API.
- **Local Storage**: Uses **Isar Database** for fast, offline-first persistence.
- **Organization**: Words are indexed and sorted by the date they were added.
- **Cross-Platform**: Supports Android, iOS, and Web.

## Getting Started

### Prerequisites

- Flutter SDK (v3.10+)
- Dart SDK
- Android Studio / Xcode (for mobile development)

### Installation

1. Clone the repository.
2. Fetch dependencies:
   ```bash
   flutter pub get
   ```
3. Generate Isar database code:
   ```bash
   flutter pub run build_runner build
   ```

## How to Run

### Mobile (Android/iOS)
Ensure you have an emulator running or a physical device connected.
```bash
flutter run
```

### Web
```bash
flutter run -d chrome
```

## How to Debug

1. **IDE Debugging**: Open the project in VS Code or Android Studio. Set breakpoints in the `.dart` files and press `F5` (VS Code) or the "Debug" button (Android Studio).
2. **DevTools**: While the app is running, use Flutter DevTools to inspect the widget tree, monitor network requests, and profile performance.
   ```bash
   # If running from CLI, press 'v' to open DevTools
   ```

## How to Check the Database Data

This app uses **Isar**, which provides a powerful web-based inspector.

1. Run the app in **debug mode** (mobile or desktop).
2. Check the console output. Isar will print a link to the **Isar Inspector**:
   ```text
   Isar Inspector: http://localhost:PORT/index.html#/
   ```
3. Open that link in your browser to:
   - View all `WordEntry` records.
   - Filter and search for specific words.
   - Add, edit, or delete entries directly in the database.
   - Execute queries for debugging purposes.

## Development Commands

- **Build Runner (Watch mode)**: Automatically updates generated files when models change.
  ```bash
  flutter pub run build_runner watch --delete-conflicting-outputs
  ```
- **Static Analysis**:
  ```bash
  flutter analyze
  ```
