import '../screens/add_edit_note.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev;
import 'package:note/api.dart';
import '../models/note.dart';
import '../models/user.dart';

class ShowUserNote extends StatefulWidget {
  const ShowUserNote({
    super.key,
    required this.userModel,
    required this.notes,
    required this.isAdmin,
    required this.users,
  });

  final User userModel;
  final List<Note> notes;
  final List<User> users;
  final bool isAdmin;

  @override
  State<ShowUserNote> createState() => _ShowUserNoteState();
}

class _ShowUserNoteState extends State<ShowUserNote> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: widget.isAdmin
          ? null
          : FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddNoteUser(
                      userModel: User(
                        -1,
                        widget.userModel.userName,
                        widget.userModel.userPass,
                      ),
                      noteModel: Note(
                        -1,
                        '',
                        '',
                        Colors.white.value.toRadixString(16),
                        0,
                      ),
                    ),
                  ),
                );
              },
              child: const Icon(Icons.add),
            ),
      appBar: AppBar(
        title: Text(widget.isAdmin ? 'ADMIN PANEL' : widget.userModel.userName),
        centerTitle: true,
      ),
      body: Column(
        children: notesWidget(widget.userModel, widget.notes, widget.isAdmin,
            widget.users, context),
      ),
    );
  }
}

Widget notWidget(
  User userModel,
  Note notModel,
  bool isAdmin,
  List<User> users,
  BuildContext context,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Container(
        color: Color(int.parse('0xFF${notModel.color.substring(1)}')),
        width: double.infinity,
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            isAdmin
                ? Text(
                    ApiNote.searchUserFromUsers(
                      users,
                      notModel.noteConnect,
                    ).userName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )
                : const Text(''),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  notModel.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(notModel.content),
              ],
            ),
            isAdmin
                ? const Text('')
                : Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          dev.log(
                              'click edit for ${userModel.userName} - edit note : ${notModel.id} title : ${notModel.title}');
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => AddNoteUser(
                                userModel: User(
                                  userModel.id,
                                  userModel.userName,
                                  userModel.userPass,
                                ),
                                noteModel: Note(
                                  notModel.id,
                                  notModel.title,
                                  notModel.content,
                                  notModel.color,
                                  notModel.noteConnect,
                                ),
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.delete),
                      )
                    ],
                  )
          ],
        )),
  );
}

List<Widget> notesWidget(
  User userModel,
  List<Note> notes,
  bool isAdmin,
  List<User> users,
  BuildContext context,
) {
  List<Widget> finalWidget = [];

  for (Note notModel in notes) {
    finalWidget.add(
      notWidget(
        userModel,
        notModel,
        isAdmin,
        users,
        context,
      ),
    );
  }

  return finalWidget;
}
