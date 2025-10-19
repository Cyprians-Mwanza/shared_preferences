import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/note.dart';
import '../../services/local/shared_prefs_helper.dart';
import 'note_state.dart';
import 'package:uuid/uuid.dart';

class NoteCubit extends Cubit<NoteState> {
  final SharedPrefsHelper _prefsHelper = SharedPrefsHelper();
  final _uuid = const Uuid();

  NoteCubit() : super(NoteInitial());

  Future<void> fetchAllNotes() async {
    emit(NoteLoading());
    try {
      final notes = await _prefsHelper.getNotes();
      emit(NoteLoaded(notes));
    } catch (e) {
      emit(NoteError('Failed to fetch notes: $e'));
    }
  }

  Future<void> addNote(Note note) async {
    try {
      final newNote = note.copyWith(id: _uuid.v4());
      await _prefsHelper.addNote(newNote);
      emit(NoteActionSuccess('Note added.'));
      fetchAllNotes();
    } catch (e) {
      emit(NoteError('Failed to add note: $e'));
    }
  }

  Future<void> updateNoteById(Note note) async {
    try {
      await _prefsHelper.updateNote(note);
      emit(NoteActionSuccess('Note updated.'));
      fetchAllNotes();
    } catch (e) {
      emit(NoteError('Failed to update note: $e'));
    }
  }

  Future<void> deleteNoteById(String id) async {
    try {
      await _prefsHelper.deleteNoteById(id);
      emit(NoteActionSuccess('Note deleted.'));
      fetchAllNotes();
    } catch (e) {
      emit(NoteError('Failed to delete note: $e'));
    }
  }
}
