import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/note.dart';

class SharedPrefsHelper {
  static const _notesKey = 'notes_list';

  Future<List<Note>> getNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_notesKey);
    if (jsonString == null) return [];
    final List data = json.decode(jsonString);
    return data.map((e) => Note.fromMap(e)).toList();
  }

  Future<void> saveNotes(List<Note> notes) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = json.encode(notes.map((n) => n.toMap()).toList());
    await prefs.setString(_notesKey, encoded);
  }

  Future<void> addNote(Note note) async {
    final notes = await getNotes();
    notes.insert(0, note);
    await saveNotes(notes);
  }

  Future<void> updateNote(Note updatedNote) async {
    final notes = await getNotes();
    final index = notes.indexWhere((n) => n.id == updatedNote.id);
    if (index != -1) {
      notes[index] = updatedNote;
      await saveNotes(notes);
    }
  }

  Future<void> deleteNoteById(String id) async {
    final notes = await getNotes();
    notes.removeWhere((n) => n.id == id);
    await saveNotes(notes);
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_notesKey);
  }
}
