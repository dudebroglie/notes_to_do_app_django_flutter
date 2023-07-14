import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '/urls.dart';
import 'note.dart';

class UpdatePage extends StatefulWidget {
  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  late Note _note;
  TextEditingController _bodyController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _note = ModalRoute.of(context)!.settings.arguments as Note;
    _bodyController.text = _note.body;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Note'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _bodyController,
              decoration: InputDecoration(
                labelText: 'Body',
              ),
              keyboardType: TextInputType.multiline,
              maxLines: null,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                updateNote(); // Update the note using the API
                Navigator.pop(context);
              },
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  // Update the note using the API
  Future<void> updateNote() async {
    final response = await http.put(
      Uri.parse(Urls.updateNoteEndpoint(_note.id)),
      body: json.encode({
        'body': _bodyController.text,
      }),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update note');
    }
  }
}
