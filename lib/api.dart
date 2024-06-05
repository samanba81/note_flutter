import 'controllers/holder_user_controller.dart';
import 'controllers/show_note_controller.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as dev;
import 'package:get/get.dart';
import 'models/response.dart';
import 'models/note.dart';
import 'models/user.dart';
import 'dart:convert';

class ApiNote {
  static int port = 8000;
  static String urlBase = "http://127.0.0.1:$port";
  static String urlApi = "$urlBase/apis";

  static User get getUserFromHolder {
    var controller = Get.find<HolderUserController>();
    return controller.user.value;
  }

  static void refreshNotes(List<Note> notes) {
    var controller = Get.find<ShowNoteController>();
    controller.notes.value = notes;
  }

  static Future<LoginResponse> get getNotes async {

    User user = getUserFromHolder;
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
          }
      }
    } else {
      dev.log("HaveError");
    }
    return LoginResponse(notes, users, message);
  }

  static Future<String> createUser(User user) async {
    String message = "";
    String url = "$urlApi/create_user";
    Map<String, String> data = {
      "userName": user.userName,
      "userPass": user.userPass,
    };
    var response = await http.post(Uri.parse(url), body: data);
    message = jsonDecode(response.body)['message'];
    return message;
  }

  static Future<String> createNote(Note note) async {
    User user = getUserFromHolder;
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
      refreshNotes(notes);
    }
    return message;
  }

  static Future<String> editNote(note) async {
    User user = getUserFromHolder;
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

    var response = await http.post(
      Uri.parse(url),
      body: dataPost,
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body.toString());
      message = json['message'];
      notes = Note.notesFromJson(json['notes'] as List<dynamic>, false);
      refreshNotes(notes);
    }
    return message;
  }

  static Future<String> deleteNote(Note note) async {
    User user = getUserFromHolder;
    List<Note> notes = [];
    String message = "ERROR";
    String url = "$urlApi/delete_note";
    Map<String, dynamic> data = {
      "userName": user.userName,
      "userPass": user.userPass,
      "noteId": note.id.toString(),
    };
    var response = await http.post(Uri.parse(url), body: data);
    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body.toString());
      message = json['message'];
      notes = Note.notesFromJson(json['notes'] as List<dynamic>, false);
      refreshNotes(notes);
    }
    return message;
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
