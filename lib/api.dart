import 'package:http/http.dart' as http;
import 'dart:developer' as dev;
import 'models/response.dart';
import 'models/note.dart';
import 'models/user.dart';
import 'dart:convert';

class ApiNote {
  static int port = 8000;
  static String urlBase = "http://127.0.0.1:$port";
  static String urlApi = "$urlBase/apis";

  static Future<LoginResponse> getNotes(User user) async {
    List<User> users = [];
    List<Note> notes = [];
    String message = "";
    String url =
        "$urlApi/get_notes?userName=${user.userName}&userPass=${user.userPass}";
    var response = await http.get(Uri.parse(url));

    Map<String, dynamic> json = jsonDecode(response.body.toString());
    message = json['message'];

    if (response.statusCode == 200) {
      switch (message) {
        case "Ok":
          {
            notes = Note.notesFromJson(json['notes'] as List<dynamic>, false);
          }
        case "WelcomeAdmin":
          {
            notes = Note.notesFromJson(json['notes'] as List<dynamic>, true);
            users = User.usersFromJson(json['users'] as List<dynamic>);
            dev.log("users -> ");
            for (User user in users) {
              dev.log(user.toString());
            }
            dev.log("notes -> ");
            for (Note note in notes) {
              dev.log(note.toString());
            }
          }
      }
    } else {
      dev.log(response.statusCode.toString());
      dev.log(response.body.toString());
    }
    return LoginResponse(notes, users, message);
  }

  static Future<RegisterResponse> createUser(User user) async {
    String message = "";
    String url = "$urlApi/create_user";
    Map<String, String> data = {
      "userName": user.userName,
      "userPass": user.userPass,
    };
    var response = await http.post(Uri.parse(url), body: data);
    message = jsonDecode(response.body)['message'];
    return RegisterResponse(message);
  }

  static Future<CreateNoteResponse> createNote(User user, Note note) async {
    String message = "ERROR";
    List<Note> notes = [];

    String url = "$urlApi/create_note";

    Map<String, dynamic> data = {
      'userName': user.userName,
      'userPass': user.userPass,
      'title': note.title,
      'content': note.content,
      'color': note.color,
    };

    var response = await http.post(Uri.parse(url), body: data);
    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body.toString());
      message = json['message'];
      notes = Note.notesFromJson(json['notes'] as List<dynamic>, false);
    }
    return CreateNoteResponse(message, notes);
  }

  static Future<EditNoteResponse> editNote(User user, Note note) async {
    String message = "ERROR";
    List<Note> notes = [];
    String url = "$urlApi/edit_note";
    Map<dynamic, dynamic> dataPost = {
      "userName": user.userName,
      "userPass": user.userPass,
      "noteId": note.id.toString(),
      "title": note.title,
      "content": note.content,
      "color": note.color
    };
    dev.log(dataPost.toString());

    var response = await http.post(
      Uri.parse(url),
      body: dataPost,
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body.toString());
      message = json['message'];
      notes = Note.notesFromJson(json['notes'] as List<dynamic>, false);
    }

    return EditNoteResponse(message, notes);
  }

  static User searchUserFromUsers(List<User> users, int userId) {
    for (User user in users) {
      if (user.id == userId) {
        return user;
      }
    }
    return User(0, "ERROR", "ERROR");
  }
}
