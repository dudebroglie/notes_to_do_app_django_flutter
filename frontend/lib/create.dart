import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'note.dart';
import 'urls.dart';

class CreatePage extends StatefulWidget {
  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  TextEditingController _bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Note'),
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
                createNote();
                Navigator.pop(context);
              },
              child: Text('Create'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> createNote() async {
    final response = await http.post(
      Uri.parse(Urls.createNoteEndpoint),
      body: json.encode({
        'body': _bodyController.text,
      }),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create note');
    }
  }
}
