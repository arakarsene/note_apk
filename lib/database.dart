import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

// Table Notes
class Notes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 50)();
  TextColumn get content => text().named('body')();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// La classe Database
@DriftDatabase(tables: [Notes])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // CRUD
  Future<int> addNote(NotesCompanion note) => into(notes).insert(note);
  Future<List<Note>> getAllNotes() => select(notes).get();
  Future<int> deleteNote(int id) => (delete(notes)..where((t) => t.id.equals(id))).go();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    // Ouvre ou crée la base "notes.sqlite" dans le bon répertoire (app support dir)
    final db = await driftDatabase(name : 'notes.sqlite');
    return db;
  });
}   
