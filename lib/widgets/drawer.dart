import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:my_expenses_manager/models/connection.dart';
import 'package:my_expenses_manager/models/storage.dart';
import 'package:my_expenses_manager/models/transactions_filter.dart';
import 'package:my_expenses_manager/models/utilities.dart';
import 'package:my_expenses_manager/pages/login_page.dart';
import 'package:my_expenses_manager/pages/setting_page.dart';
import 'package:my_expenses_manager/widgets/loading_widget.dart';
import 'package:my_expenses_manager/widgets/message_dialog.dart';
import 'package:provider/provider.dart';

class SideDrawer extends StatefulWidget {
  const SideDrawer({Key? key}) : super(key: key);

  @override
  State<SideDrawer> createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  Widget drawerItem(
      {required String title,
      required Icon icon,
      required VoidCallback callback}) {
    return ListTile(
      onTap: callback,
      leading: Padding(
          padding: const EdgeInsets.only(
            left: 18,
            right: 10,
          ),
          child: icon),
      title: Text(
        title,
        style: TextStyle(
            color: Colors.white, fontSize: SizeController.setHeight(0.03)),
      ),
    );
  }

  void logout() async {
    LoadingWidget.show(context);
    try {
      Storage storage =
          Provider.of<TransactionsFilter>(context, listen: false).getStorage();

      await storage.sync();
      await Connection.makeConnection().request('/users/logout',
          data: {"token": "${Connection.getToken()}"},
          options: Options(method: "POST"));
      await Connection.removeLoginInfo();
      Utils.showToastMsg("Logout Successfully!");
      Navigator.of(context).pop();
      setState(() {});
    } catch (e) {
      Utils.showToastMsg(
          "Unable to logout. Make sure the internet connection is stable");
      Navigator.of(context).pop();
    }
  }

  Future loginSetup() async {
    try {
      var confirmImport = await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return const MessageDialog(
              title: "Login Setup",
              message:
                  "Import data from server, or rewrite with data in device's local storage?",
              firstOption: "Rewrite",
              secondOption: "Import",
            );
          });

      LoadingWidget.show(context);
      TransactionsFilter transactionFilter =
          Provider.of<TransactionsFilter>(confirmImport[1], listen: false);

      // if rewrite
      if (!confirmImport[0]) {
        await transactionFilter.getStorage().reWriteDataToServer();
        Navigator.of(context).pop();
        return;
      }

      // if import
      await transactionFilter.getStorage().importTransaction();
      Navigator.of(context).pop();
    } catch (error) {
      Navigator.of(context).pop();
      Utils.showToastMsg("Please check your internet connection");
      loginSetup();
    }
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<TransactionsFilter>(context);
    return Drawer(
      backgroundColor: CustomColors.darkBlue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.all(15),
            color: Connection.isLoggedin() ? Colors.green : Colors.red,
            height: SizeController.setHeight(0.3),
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    Connection.isLoggedin()
                        ? "Welcome ${Connection.getUserName()}"
                        : "Welcome Guest",
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    Connection.isLoggedin()
                        ? "You are logged in"
                        : "Please sign in",
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ],
            )),
          ),
          drawerItem(
              icon: Icon(
                Icons.settings,
                color: Colors.white,
                size: SizeController.setHeight(0.05),
              ),
              title: "Setting",
              callback: () {
                Navigator.of(context).pushNamed(SettingPage.routeName);
              }),
          !Connection.isLoggedin()
              ? drawerItem(
                  icon: Icon(
                    Icons.login,
                    color: Colors.white,
                    size: SizeController.setHeight(0.05),
                  ),
                  title: "Login",
                  callback: () {
                    Navigator.of(context)
                        .pushNamed(LoginPage.routeName)
                        .then((justLogin) {
                      if (justLogin != null) {
                        loginSetup();
                      }
                    });
                  })
              : drawerItem(
                  icon: Icon(
                    Icons.logout,
                    color: Colors.white,
                    size: SizeController.setHeight(0.05),
                  ),
                  title: "Logout",
                  callback: logout,
                )
        ],
      ),
    );
  }
}
