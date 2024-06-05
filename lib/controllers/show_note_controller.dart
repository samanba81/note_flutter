import '../models/user.dart';
import '../models/response.dart';
import 'package:get/get.dart';
import '../models/note.dart';
import '/api.dart';

class ShowNoteController extends GetxController {
  RxString message = "".obs;
  RxList<Note> notes = RxList();
  RxList<User> users = RxList();
  RxBool isLoading = false.obs;
  RxBool isAdmin = false.obs;

  @override
  void onInit() {
    fetchNotes();
    super.onInit();
  }

  void fetchNotes() async {
    isLoading(true);
    LoginResponse response = await ApiNote.getNotes;
    notes.value = response.notes;
    users.value = response.users;
    message.value = response.message;
    isAdmin(response.message == "WelcomeAdmin");
    isLoading(false);
  }
}
