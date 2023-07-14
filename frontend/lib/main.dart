import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '/create.dart';
import '/update.dart';
import '/note.dart';
import '/urls.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(),
        '/create': (context) => CreatePage(),
        '/update': (context) => UpdatePage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Note> _notes = [];

  Future<void> _fetchNotes() async {
    final response = await http.get(Uri.parse(Urls.notesEndpoint));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      _notes = jsonList.map((json) => Note.fromJson(json)).toList();
      setState(() {});
    } else {
      throw Exception('Failed to fetch notes');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes or ToDo List'),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchNotes,
        child: ListView.builder(
          itemCount: _notes.length,
          itemBuilder: (BuildContext context, int index) {
            Note note = _notes[index];
            return Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: ListTile(
                  title: Text(note.body),
                  subtitle: Text(
                      'Created: ${note.created}, Updated: ${note.updated}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      deleteNote(note.id); // Delete the note using the API
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Note deleted')),
                      );
                    },
                  ),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/update',
                      arguments: note,
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, '/create');
        },
      ),
    );
  }
}

// Fetch the list of notes from the API
Future<List<Note>> fetchNotes() async {
  final response = await http.get(Uri.parse(Urls.notesEndpoint));
  if (response.statusCode == 200) {
    final List<dynamic> jsonList = json.decode(response.body);
    return jsonList.map((json) => Note.fromJson(json)).toList();
  } else {
    throw Exception('Failed to fetch notes');
  }
}

// Delete a note using the API
Future<void> deleteNote(int id) async {
  final response = await http.delete(Uri.parse(Urls.deleteNoteEndpoint(id)));
  if (response.statusCode != 204) {
    throw Exception('Failed to delete note');
  }
}
