import 'dart:convert';

class Note {
  final int id;
  final String body;
  final String updated;
  final String created;

  Note({
    required this.id,
    required this.body,
    required this.updated,
    required this.created,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      body: json['body'],
      updated: json['updated'],
      created: json['created'],
    );
  }

  List<Note> parseNotes(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Note>((json) => Note.fromJson(json)).toList();
  }
}
