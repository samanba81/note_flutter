// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:note/models/response.dart';
import 'package:note/models/user.dart';
import 'package:note/screens/show_notes.dart';
import '../api.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var userNameController = TextEditingController();
  var userPassController = TextEditingController();
  var userRePassController = TextEditingController();

  String errorUserName = "";
  String errorUserPass = "";
  String errorUserRePass = "";

  @override
  Widget build(BuildContext context) {
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
            child: TextField(
              textAlign: TextAlign.center,
              controller: userNameController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                label: const Text('User Name'),
                hintText: 'Enter Your Chosen User Name',
                errorText: (errorUserName.isNotEmpty) ? errorUserName : null,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              textAlign: TextAlign.center,
              controller: userPassController,
              obscureText: true,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                alignLabelWithHint: true,
                label: const Text('User Pass'),
                hintText: 'Enter Your Chosen Password',
                errorText: (errorUserPass.isNotEmpty) ? errorUserPass : null,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              textAlign: TextAlign.center,
              controller: userRePassController,
              obscureText: true,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                alignLabelWithHint: true,
                label: const Text('User Pass Again'),
                hintText: 'Enter Your Chosen Password Again',
                errorText:
                    (errorUserRePass.isNotEmpty) ? errorUserRePass : null,
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
              errorUserName = "";
              errorUserPass = "";
              errorUserRePass = "";
              if (userNameController.text.length < 4) {
                setState(() => errorUserName = "User Name Is Short");
                return;
              }
              if (userPassController.text.length < 8) {
                setState(() => errorUserPass = "Password Is Short");
                return;
              }
              if (userPassController.text != userRePassController.text) {
                setState(() =>
                    errorUserRePass = "Password and Re Password Not Equal");
                return;
              }

              User user = User(
                0,
                userNameController.text,
                userPassController.text,
              );

              RegisterResponse registerResponse =
                  await ApiNote.createUser(user);

              switch (registerResponse.message) {
                case "WeHaveThisUserName":
                  setState(() => errorUserName = "We Have This UserName");
                case "UserCreated":
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ShowUserNote(
                        userModel: user,
                        notes: const [],
                        isAdmin: false,
                        users: const [],
                      ),
                    ),
                  );
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
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
