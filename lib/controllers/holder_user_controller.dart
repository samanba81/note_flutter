import 'package:get/get.dart';
import '../models/user.dart';

class HolderUserController extends GetxController {
  Rx<User> user = User(0, "", "").obs;
}
