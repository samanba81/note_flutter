import 'user.dart';
import 'note.dart';

class LoginResponse {
  List<Note> notes = [];
  List<User> users = [];
  String message = "";

  LoginResponse(this.notes, this.users, this.message);

  static LoginResponse adminLogin(Map<String, dynamic> json) {
    List<Note> notes =
        Note.notesFromJson(json['notes'] as List<dynamic>, false);
    List<User> users = User.usersFromJson(json['users'] as List<dynamic>);
    return LoginResponse(notes, users, "");
  }

  static LoginResponse userLogin(Map<String, dynamic> json) {
    List<Note> notes =
        Note.notesFromJson(json['notes'] as List<dynamic>, false);
    return LoginResponse(notes, [], "");
  }

  static LoginResponse errorLogin(Map<String, dynamic> json) {
    String message = json['message'];
    return LoginResponse([], [], message);
  }
}