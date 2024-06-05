// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:note/screens/show_notes.dart';
import '../models/response.dart';
import '../models/user.dart';
import 'register.dart';
import '../api.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var userNameController = TextEditingController();
  var userPassController = TextEditingController();

  String errorUserName = "";
  String errorUserPass = "";

  @override
  Widget build(BuildContext context) {
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
            child: TextField(
              textAlign: TextAlign.center,
              controller: userNameController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                label: const Text('UserName'),
                hintText: 'Enter Your User Name',
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
                label: const Text('UserPass'),
                hintText: 'Enter Your Password',
                errorText: (errorUserPass.isNotEmpty) ? errorUserPass : null,
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
              errorUserName = "";
              errorUserPass = "";
              User user = User(
                0,
                userNameController.text,
                userPassController.text,
              );

              LoginResponse loginResponse = await ApiNote.getNotes(user);

              switch (loginResponse.message) {
                case "UserNotExist":
                  setState(() => errorUserName = "User Not Exist");
                case "InvalidPassword":
                  setState(() => errorUserPass = "Invalid Password");
                case "Ok":
                  {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ShowUserNote(
                          userModel: user,
                          notes: loginResponse.notes,
                          isAdmin: false,
                          users: const [],
                        ),
                      ),
                    );
                  }
                case "WelcomeAdmin":
                  {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ShowUserNote(
                          userModel: user,
                          notes: loginResponse.notes,
                          isAdmin: true,
                          users: loginResponse.users,
                        ),
                      ),
                    );
                  }
              }
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
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const RegisterPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
