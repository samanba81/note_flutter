import '/controllers/register_controller.dart';
import 'package:flutter/material.dart';
import '/screens/show_notes.dart';
import 'package:get/get.dart';
import '../models/user.dart';
import '../api.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(RegisterController());

    var userNameController = TextEditingController();
    var userPassController = TextEditingController();
    var userRePassController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Page'),
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
                  label: const Text('User Name'),
                  hintText: 'Enter Your Chosen User Name',
                  errorText: (controller.errorUserName.isNotEmpty)
                      ? controller.errorUserName.value
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
                  label: const Text('User Pass'),
                  hintText: 'Enter Your Chosen Password',
                  errorText: (controller.errorUserPass.isNotEmpty)
                      ? controller.errorUserPass.value
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
                controller: userRePassController,
                obscureText: true,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  alignLabelWithHint: true,
                  label: const Text('User Pass Again'),
                  hintText: 'Enter Your Chosen Password Again',
                  errorText: (controller.errorUserRePass.isNotEmpty)
                      ? controller.errorUserRePass.value
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
            child: const Text('REGISTER'),
            onPressed: () async {
              controller.errorUserName.value = "";
              controller.errorUserPass.value = "";
              controller.errorUserRePass.value = "";
              if (userNameController.text.length < 4) {
                controller.errorUserName.value = "User Name Is Short";
                return;
              }
              if (userPassController.text.length < 8) {
                controller.errorUserPass.value = "Password Is Short";
                return;
              }
              if (userPassController.text != userRePassController.text) {
                controller.errorUserRePass.value =
                    "Password and Re Password Not Equal";
                return;
              }

              User user = User(
                0,
                userNameController.text,
                userPassController.text,
              );

              String registerResponse = await ApiNote.createUser(user);

              switch (registerResponse) {
                case "WeHaveThisUserName":
                  controller.errorUserName.value = "We Have This UserName";
                case "UserCreated":
                  Get.to(() => const ShowUserNote());
              }
            },
          ),
          const SizedBox(height: 25),
          const Text("If You Have Account"),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blueGrey),
              minimumSize: MaterialStateProperty.resolveWith(
                (states) => const Size(250, 40),
              ),
            ),
            child: const Text('Login'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
