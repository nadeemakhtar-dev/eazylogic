
# Notes App

A simple **Flutter Notes App** with **CRUD (Create, Read, Update, Delete)** functionality, powered by the **Hive database** for offline data storage. This app allows users to create, manage, and delete notes efficiently without the need for an internet connection.

## Features

- **Create Notes**: Add new notes with a title and description.
- **Read Notes**: View a list of all saved notes and individual note details.
- **Update Notes**: Edit existing notes with new content.
- **Delete Notes**: Remove notes when no longer needed.
- **Offline Storage**: The app uses Hive, a lightweight and fast key-value database for persistent offline storage.
- **Responsive UI**: Fully responsive, adapting to different screen sizes and orientations.

## Getting Started

### Prerequisites

Before running the project, ensure you have the following setup:

- [Flutter SDK](https://flutter.dev/docs/get-started/install) installed
- A Flutter-supported IDE (VS Code, Android Studio, etc.)
- Dart installed (usually comes with Flutter)

### Setup

1. Clone the repository:

   ```bash
   git clone https://github.com/yourusername/notes-app.git
   ```

2. Navigate to the project directory:

   ```bash
   cd notes-app
   ```

3. Install dependencies:

   ```bash
   flutter pub get
   ```

4. Run the app:

   ```bash
   flutter run
   ```

### Hive DB Setup

The app uses **Hive** for storing notes locally. No external database or server is required.

1. Add the required Hive dependencies in `pubspec.yaml`:

   ```yaml
   dependencies:
     flutter:
       sdk: flutter
     hive: ^2.0.0
     hive_flutter: ^1.1.0

   dev_dependencies:
     hive_generator: ^1.1.0
     build_runner: ^2.1.0
   ```

2. Initialize Hive in the app:

   In your `main.dart` file:

   ```dart
   import 'package:hive_flutter/hive_flutter.dart';

   void main() async {
     await Hive.initFlutter();
     await Hive.openBox('notesBox');
     runApp(MyApp());
   }
   ```

3. Create a Hive model for the Note object:

   ```dart
   import 'package:hive/hive.dart';

   part 'note.g.dart';

   @HiveType(typeId: 0)
   class Note extends HiveObject {
     @HiveField(0)
     late String title;

     @HiveField(1)
     late String description;
   }
   ```

4. Generate the Hive adapter by running:

   ```bash
   flutter packages pub run build_runner build
   ```

### CRUD Operations with Hive

- **Create a note**:

   ```dart
   var box = Hive.box('notesBox');
   box.add(Note()
     ..title = 'New Note'
     ..description = 'Note description');
   ```

- **Read notes**:

   ```dart
   var notes = box.values.toList();
   ```

- **Update a note**:

   ```dart
   note.title = 'Updated Note';
   note.save();
   ```

- **Delete a note**:

   ```dart
   note.delete();
   ```

## Project Structure

```plaintext
lib/
├── explanationPage/
│   └── hive.html          
│   └── mainfile.html          
│   └── NoteGenerator.html           
├── main.dart               # App entry point
│── NoteAddScreen.dart    # Home screen listing all notes
├── models/
│   └── note.dart           # Note model using Hive
│   └── note.g.dart           # Note Adapter for serialization and De-serialization

```

## Dependencies

- [Flutter](https://flutter.dev/)
- [Hive](https://pub.dev/packages/hive)
- [Hive Flutter](https://pub.dev/packages/hive_flutter)
- [Hive Generator](https://pub.dev/packages/hive_generator)
- [Build Runner](https://pub.dev/packages/build_runner)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
