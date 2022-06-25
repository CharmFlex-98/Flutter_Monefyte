import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:my_expenses_manager/models/connection.dart';
import 'package:my_expenses_manager/models/utilities.dart';
import 'package:my_expenses_manager/widgets/loading_widget.dart';

class SignUpPage extends StatefulWidget {
  static const routeName = '/SignUpPage';

  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController password = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController userName = TextEditingController();

  void createUser() async {
    LoadingWidget.show(context);
    try {
      await Connection.makeConnection().request('/users',
          data: {
            "userName": userName.text,
            "email": email.text,
            "password": password.text
          },
          options: Options(method: "POST"));
      Utils.showToastMsg("User created! Proceed to login page!");
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    } catch (e) {
      Utils.showToastMsg(
          "Error occurred.\nConnection problem, or\nInvalid email/password");
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Sign Up'),
        ),
        body: Center(
            child: SingleChildScrollView(
          child: SizedBox(
            width: SizeController.setWidth(context, 0.75),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(
                      hintText: 'example@gmail.com', labelText: "Email"),
                  controller: email,
                ),
                TextField(
                  decoration: const InputDecoration(
                      hintText: 'set a nice name!', labelText: "username"),
                  controller: userName,
                ),
                TextField(
                  decoration: const InputDecoration(
                      hintText: '6 characters or above', labelText: "password"),
                  controller: password,
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: createUser, child: const Text('Sign Up!')),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        )));
  }
}
