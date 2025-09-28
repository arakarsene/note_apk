import 'package:flutter/material.dart';
import 'database.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final db = AppDatabase();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NotesPage(db: db),
    );
  }
}

class NotesPage extends StatefulWidget {
  final AppDatabase db;
  const NotesPage({super.key, required this.db});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  List<Note> notes = [];

  final titleController = TextEditingController();
  final contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final data = await widget.db.getAllNotes();
    setState(() {
      notes = data;
    });
  }

  Future<void> _addNote() async {
    if (titleController.text.isEmpty || contentController.text.isEmpty) return;
    await widget.db.addNote(
      NotesCompanion.insert(
        title: titleController.text,
        content: contentController.text,
      ),
    );
    titleController.clear();
    contentController.clear();
    _loadNotes();
  }

  Future<void> _deleteNote(int id) async {
    await widget.db.deleteNote(id);
    _loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mes Notes")),
      body: Column(
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(labelText: "Titre"),
          ),
          TextField(
            controller: contentController,
            decoration: InputDecoration(labelText: "Contenu"),
          ),
          ElevatedButton(
            onPressed: _addNote,
            child: Text("Ajouter"),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return ListTile(
                  title: Text(note.title),
                  subtitle: Text(note.content),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteNote(note.id),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
