import 'package:get/get.dart';
import '../models/note.dart';
import 'package:flutter/material.dart';

class AddEditController extends GetxController {
  Rx<Color> colorSelect = Colors.white.obs;
  Rx<TextEditingController> noteControllerTitle = TextEditingController().obs;
  Rx<TextEditingController> noteControllerText = TextEditingController().obs;

  AddEditController(this.note);

  Note note;

  @override
  void onInit() {
    init();
    super.onInit();
  }

  void init() {
    noteControllerTitle.value.text = note.title;
    noteControllerText.value.text = note.content;
    colorSelect.value = Color(int.parse(note.color, radix: 16));
  }
}
