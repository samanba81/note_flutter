// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:note/api.dart';
import 'package:note/models/response.dart';
import 'package:note/screens/login.dart';
import 'dart:developer' as dev;
import '../models/user.dart';
import '../models/note.dart';
import 'show_notes.dart';

// ignore: must_be_immutable
class AddNoteUser extends StatefulWidget {
  AddNoteUser({
    super.key,
    required this.userModel,
    required this.noteModel,
  });

  final User userModel;
  Note noteModel;

  @override
  State<AddNoteUser> createState() => _AddNoteUserState();
}

class _AddNoteUserState extends State<AddNoteUser> {
  List<Color> colorList1 = [
    const Color(0xFFF44336),
    const Color(0xFF2196F3),
    const Color(0xFF607D8B),
    const Color(0xFFE91E63),
    const Color(0xFFFF9800),
  ];
  List<Color> colorList2 = [
    const Color(0xFFFF5252),
    const Color(0xFF448AFF),
    const Color(0xFFFF5722),
    const Color(0xFFFF4081),
    const Color(0xFFFFAB40),
  ];
  Color colorSelect = Colors.white;
  var notControllerTitle = TextEditingController();
  var notControllerText = TextEditingController();

  Widget buttonColor(Color mColor) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: InkWell(
        onTap: () => setState(() => colorSelect = mColor),
        child: Container(
          decoration: BoxDecoration(shape: BoxShape.circle, color: mColor),
          height: 60,
          width: 60,
          child: (mColor == colorSelect) ? const Icon(Icons.add_circle) : null,
        ),
      ),
    );
  }

  @override
  void initState() {
    notControllerTitle.text = widget.noteModel.title;
    notControllerText.text = widget.noteModel.content;
    colorSelect = Color(int.parse(widget.noteModel.color, radix: 16));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Text('Create New Note'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Container(
              height: 60,
              color: colorSelect,
              child: TextField(
                controller: notControllerTitle,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 20),
                  border: OutlineInputBorder(),
                  hintText: 'Enter Your Title',
                ),
              ),
            ),
          ),
          Container(
            height: 100,
            color: colorSelect,
            child: TextField(
              controller: notControllerText,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 50),
                border: OutlineInputBorder(),
                hintText: 'Enter Your Text',
              ),
            ),
          ),
          // TextField - EnterYourNote
          const SizedBox(height: 50),
          const Text('Select Your Background Color'),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [for (var color in colorList1) buttonColor(color)]),
          const SizedBox(height: 5),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [for (var color in colorList2) buttonColor(color)]),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              Note note = Note(
                widget.noteModel.id,
                notControllerTitle.text,
                notControllerText.text,
                colorSelect.value.toRadixString(16),
                widget.noteModel.noteConnect,
              );
              dev.log(note.toString());

              dev.log(
                'click ${note.id == -1 ? 'add' : 'edit note ${note.id}'}',
              );

              if (widget.noteModel.id != -1) {
                EditNoteResponse response =
                    await ApiNote.editNote(widget.userModel, note);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShowUserNote(
                      userModel: widget.userModel,
                      notes: response.notes,
                      isAdmin: false,
                      users: const [],
                    ),
                  ),
                );
              } else {
                CreateNoteResponse res =
                    await ApiNote.createNote(widget.userModel, note);
                if (res.message != "ERROR") {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ShowUserNote(
                        userModel: widget.userModel,
                        notes: res.notes,
                        isAdmin: false,
                        users: const [],
                      ),
                    ),
                  );
                } else {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: const Text('Save Note'),
          )
        ],
      ),
    );
  }
}
