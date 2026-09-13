import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note.dart';

class NotesStorage {
  static const _key = 'notes';
  static final _notes = <String, List<Note>>{};
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final raw = _prefs!.getString(_key);
    if (raw != null) {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      _notes.clear();
      map.forEach((k, v) => _notes[k] =
          (v as List).map((e) => Note.fromJson(e)).toList());
    }
  }

  static List<Note> of(String dateKey) => List.unmodifiable(_notes[dateKey] ?? []);

  static Future<void> save(Note note) async {
    _notes.putIfAbsent(note.dateKey, () => []).add(note);
    await _persist();
  }

  static Future<void> remove(String dateKey, String id) async {
    _notes[dateKey]?.removeWhere((n) => n.id == id);
    await _persist();
  }

  static Future<void> _persist() =>
      _prefs!.setString(_key, jsonEncode(
          _notes.map((k, v) => MapEntry(k, v.map((n) => n.toJson()).toList()))));
}