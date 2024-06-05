import '../controllers/holder_user_controller.dart';
import '../controllers/show_note_controller.dart';
import '../controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/user.dart';
import 'show_notes.dart';
import 'register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController userPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final LoginController loginController = Get.put(LoginController());
    final HolderUserController holder = Get.put(HolderUserController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      backgroundColor: Colors.grey,
      body: Column(
        children: <Widget>[
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Obx(
              () => TextField(
                textAlign: TextAlign.center,
                controller: userNameController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  label: const Text('UserName'),
                  hintText: 'Enter Your User Name',
                  errorText: (loginController.errorUserName.isNotEmpty)
                      ? loginController.errorUserName.value
                      : null,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Obx(
              () => TextField(
                textAlign: TextAlign.center,
                controller: userPassController,
                obscureText: true,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  alignLabelWithHint: true,
                  label: const Text('UserPass'),
                  hintText: 'Enter Your Password',
                  errorText: (loginController.errorUserPass.isNotEmpty)
                      ? loginController.errorUserPass.value
                      : null,
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blueGrey),
              minimumSize: MaterialStateProperty.resolveWith(
                (states) => const Size(250, 40),
              ),
            ),
            child: const Text('LOGIN'),
            onPressed: () async {
              loginController.errorUserName.value = "";
              loginController.errorUserPass.value = "";
              User user = User(
                0,
                userNameController.text,
                userPassController.text,
              );

              holder.user.value = user;

              var controller = Get.put(ShowNoteController());
              controller.fetchNotes();
              Future.delayed(const Duration(milliseconds: 300), () {
                switch (controller.message.value) {
                  case "UserNotExist":
                    loginController.errorUserName.value = "User Not Exist";
                  case "InvalidPassword":
                    loginController.errorUserPass.value = "Invalid Password";
                  case "WelcomeAdmin":
                    {
                      Get.to(() => const ShowUserNote());
                    }
                  case "Ok":
                    {
                      Get.to(() => const ShowUserNote());
                    }
                }
              });
            },
          ),
          const SizedBox(height: 25),
          const Text("If You Don't Have Account"),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blueGrey),
              minimumSize: MaterialStateProperty.resolveWith(
                (states) => const Size(250, 40),
              ),
            ),
            child: const Text('SignUp'),
            onPressed: () => Get.to(() => const RegisterPage()),
          ),
        ],
      ),
    );
  }
}
