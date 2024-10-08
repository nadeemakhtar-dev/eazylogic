import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hivedb/main.dart';
import 'package:hivedb/models/note.dart';

class noteApp extends StatefulWidget {
  const noteApp({super.key, required this.title});

  final String title;

  @override
  State<noteApp> createState() => _noteAppState();
}

class _noteAppState extends State<noteApp> {
  final _noteBox = Hive.box<Note>('notesBox');
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  void _addNote() {
    final newNote = Note(
        name: _nameController.text,
        description: _descriptionController.text,
        date: DateTime.now());

    _noteBox.add(newNote);

    //Clear the input Fields
    _nameController.clear();
    _descriptionController.clear();

    setState(() {});
  }

  void _deleteNote(int index) {
    _noteBox.deleteAt(index);
    setState(() {});
  }

  void _updateNote(int index, Note note) {
    _nameController.text = note.name;
    _descriptionController.text = note.description;

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Update Note'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Note Name'),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration:
                      const InputDecoration(labelText: 'Note Description'),
                  maxLines: 5,
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  // Update the note in Hive
                  _noteBox.putAt(
                    index,
                    Note(
                      name: _nameController.text,
                      description: _descriptionController.text,
                      date: note.date, // Keep the original date
                    ),  
                  );

                  // Clear the text fields and close the dialog
                  _nameController.clear();
                  _descriptionController.clear();

                  Navigator.of(context).pop();
                  setState(() {
                    
                  }); // Refresh the UI
                },
                child: const Text('Update'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Clear the text fields and close the dialog
                  _nameController.clear();
                  _descriptionController.clear();
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 7, 54, 92),

        title: Text("Notes App",style: TextStyle(color: Colors.white),),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Note Name'),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration:
                      const InputDecoration(labelText: 'Enter description'),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.grey,
            thickness: 1,
          ),
          Expanded(
              child: ValueListenableBuilder(
                  valueListenable: _noteBox.listenable(),
                  builder: (context, Box<Note> box, _) {
                    if (box.values.isEmpty) {
                      return const Center(
                        child: Text("No Notes Found"),
                      );
                    }
                    return ListView.builder(
                        itemCount: box.values.length,
                        itemBuilder: (context, index) {
                          Note? note = box.getAt(index);
          
                          return Dismissible(
                            key: Key(note!.name),
                            direction: DismissDirection.horizontal,
                            confirmDismiss: (direction) async {
                              if (direction == DismissDirection.startToEnd) {
                                // Left to right swipe (edit)
                                _updateNote(index, note);
                                return false;
                              } else if (direction ==
                                  DismissDirection.endToStart) {
                                _deleteNote(index);
                                return true;
                              }
                              return false;
                            },
                            secondaryBackground: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "Delete document",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                            background: Container(
                              color: Colors.green,
                              alignment: Alignment.centerLeft,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.edit_document,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Update document",
                                    style: TextStyle(color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                            onDismissed: (direction) {
                              _deleteNote(index);
                              // Show a snackbar notification
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text(
                                      '${note.name} deleted',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    )),
                              );
                            },
                            child: Card(
                              child: ListTile(
                                title: Text(note?.name ?? ""),
                                subtitle: Text(
                                  (note?.description ?? "")
                                      .split('\n')
                                      .first, // Split and take only the first line
                                  maxLines: 1, // Ensure it only shows one line
                                  overflow: TextOverflow
                                      .ellipsis, // Add ellipsis if the line is too long
                                ),
                                trailing:
                                    Text(note?.date.toLocal().toString() ?? ''),
                              ),
                            ),
                          );
                        });
                  }))
        ],
      ),
     floatingActionButton: FloatingActionButton.extended(
        isExtended: true,
        onPressed: _addNote,
        label: Text("Add Note"),
        icon: Icon(Icons.add_comment),
      ),
    );
  }
}