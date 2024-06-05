import '../controllers/add_edit_controller.dart';
import 'package:flutter/material.dart';
import '../screens/login.dart';
import 'dart:developer' as dev;
import 'package:get/get.dart';
import '../models/note.dart';
import '../api.dart';

class AddNoteUser extends StatelessWidget {
  const AddNoteUser({
    super.key,
    required this.noteModel,
  });

  final Note noteModel;

  @override
  Widget build(BuildContext context) {
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
    var controller = Get.put(AddEditController(noteModel));
    controller.init();
    dev.log(controller.note.toString());
    dev.log(noteModel.toString());
    Widget buttonColor(Color mColor) {
      return Padding(
        padding: const EdgeInsets.all(1.0),
        child: Obx(
          () => InkWell(
            onTap: () => controller.colorSelect.value = mColor,
            child: Container(
              decoration: BoxDecoration(shape: BoxShape.circle, color: mColor),
              height: 60,
              width: 60,
              child: (mColor == controller.colorSelect.value)
                  ? const Icon(Icons.add_circle)
                  : null,
            ),
          ),
        ),
      );
    }

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
            child: Obx(
              () => Container(
                height: 60,
                color: controller.colorSelect.value,
                child: TextField(
                  controller: controller.noteControllerTitle.value,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 20),
                    border: OutlineInputBorder(),
                    hintText: 'Enter Your Title',
                  ),
                ),
              ),
            ),
          ),
          Obx(
            () => Container(
              height: 100,
              color: controller.colorSelect.value,
              child: TextField(
                controller: controller.noteControllerText.value,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 50),
                  border: OutlineInputBorder(),
                  hintText: 'Enter Your Text',
                ),
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
                noteModel.id,
                controller.noteControllerTitle.value.text,
                controller.noteControllerText.value.text,
                controller.colorSelect.value.value.toRadixString(16),
                noteModel.noteConnect,
              );

              if (noteModel.id != -1) {
                await ApiNote.editNote(note);
                Navigator.of(context).pop();
              } else {
                String res = await ApiNote.createNote(note);
                if (res != "ERROR") {
                  Navigator.of(context).pop();
                } else {
                  Get.to(() => const LoginPage());
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
