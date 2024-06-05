import 'package:flutter/material.dart';

class Note {
  int id = 0;
  String title;
  String content;
  String color;
  int noteConnect = 0;

  Note(this.id, this.title, this.content, this.color, this.noteConnect);

  static Note empty() => Note(
        -1,
        "",
        "",
        Colors.white.value.toRadixString(16),
        0,
      );

  static Note fromJson(Map<String, dynamic> data) => Note(
        data['noteId'],
        data['noteTitle'],
        data['noteContent'],
        "${data['noteColor']}",
        0,
      );

  static Note fromAdminJson(Map<String, dynamic> data) => Note(
        data['noteId'],
        data['noteTitle'],
        data['noteContent'],
        data['noteColor'],
        data['noteConnect'],
      );

  static List<Note> notesFromJson(List<dynamic> notesJson, bool isAdmin) {
    List<Note> notes = [];
    for (Map<String, dynamic> noteJson in notesJson) {
      notes.add(
        isAdmin ? Note.fromAdminJson(noteJson) : Note.fromJson(noteJson),
      );
    }
    return notes;
  }

  @override
  String toString() {
    return 'Note{id: $id, title: $title, content: $content, color: $color, noteConnect: $noteConnect}';
  }
}
