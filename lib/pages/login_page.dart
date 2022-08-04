import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:my_expenses_manager/utils/connection.dart';
import 'package:my_expenses_manager/utils/storage.dart';
import 'package:my_expenses_manager/utils/utilities.dart';
import 'package:my_expenses_manager/pages/signup_page.dart';
import 'package:my_expenses_manager/widgets/loading_widget.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/LoginPage';

  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController password = TextEditingController();
  final TextEditingController email = TextEditingController();

  void successLabel() {
    Utils.showToastMsg("Login Success!");
    Provider.of<Storage>(context, listen: false).notify();
    Navigator.of(context).pop();
    Navigator.of(context).pop(true);
  }

  void failLabel() {
    Utils.showToastMsg(
        "Error occur.\nConnection problem, or \nInvalid email/password");
    Navigator.of(context).pop();
  }

  void loginUser() async {
    LoadingWidget.show(context);
    try {
      Response response = await Connection.makeConnection().request(
          '/users/login',
          data: {"email": email.text, "password": password.text},
          options: Options(method: "POST"));
      await Connection.insertLoginInfo(
          token: response.data["token"], name: response.data["userName"]);
      successLabel();
    } catch (e) {
      failLabel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
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
                  decoration: const InputDecoration(hintText: 'Email'),
                  controller: email,
                ),
                TextField(
                  decoration: const InputDecoration(hintText: 'password'),
                  controller: password,
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: loginUser, child: const Text('Login')),
                const SizedBox(
                  height: 50,
                ),
                const Text("No account?"),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(SignUpPage.routeName);
                  },
                  child: const Text(
                    "Sign up",
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                )
              ],
            ),
          ),
        )));
  }
}
