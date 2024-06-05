import '../controllers/holder_user_controller.dart';
import '../controllers/show_note_controller.dart';
import '../screens/add_edit_note.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/note.dart';
import '../models/user.dart';
import '../api.dart';

class ShowUserNote extends StatelessWidget {
  const ShowUserNote({super.key});

  @override
  Widget build(BuildContext context) {
    final holderUser = Get.find<HolderUserController>();
    final controller = Get.find<ShowNoteController>();
    return Scaffold(
      floatingActionButton: controller.isAdmin.value
          ? null
          : FloatingActionButton(
              onPressed: () =>
                  Get.to(() => AddNoteUser(noteModel: Note.empty())),
              child: const Icon(Icons.add),
            ),
      appBar: AppBar(
        title: Obx(
          () => Text(controller.isAdmin.value
              ? 'ADMIN PANEL'
              : holderUser.user.value.userName),
        ),
        centerTitle: true,
      ),
      body: Obx(
        () => Column(
          children: notesWidget(
            controller.notes,
            controller.isAdmin.value,
            controller.users,
            context,
          ),
        ),
      ),
    );
  }
}

List<Widget> notesWidget(
  List<Note> notes,
  bool isAdmin,
  List<User> users,
  BuildContext context,
) {
  List<Widget> finalWidget = [];

  for (Note notModel in notes) {
    finalWidget.add(
      notWidget(
        notModel,
        isAdmin,
        users,
        context,
      ),
    );
  }

  return finalWidget;
}

Widget notWidget(
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
                        onPressed: () =>
                            Get.to(() => AddNoteUser(noteModel: notModel)),
                        icon: const Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () async {
                          await ApiNote.deleteNote(notModel);
                        },
                        icon: const Icon(Icons.delete),
                      )
                    ],
                  )
          ],
        )),
  );
}
