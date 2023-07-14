class Urls {
  static const String baseUrl =
      'http://10.0.2.2:8000'; // Replace with your Django base URL

  static String get notesEndpoint => '$baseUrl/notes/';
  static String createNoteEndpoint = '$baseUrl/notes/create/';
  static String deleteNoteEndpoint(int id) => '$baseUrl/notes/$id/delete/';
  static String updateNoteEndpoint(int id) => '$baseUrl/notes/$id/update/';
}
