import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_expenses_manager/models/transaction.dart';
import 'package:my_expenses_manager/models/transactions_filter.dart';
import 'package:my_expenses_manager/pages/login_page.dart';
import 'package:my_expenses_manager/pages/signup_page.dart';
import 'package:my_expenses_manager/pages/new_transaction_page.dart';
import 'package:my_expenses_manager/pages/setting_page.dart';
import 'package:my_expenses_manager/pages/splash_screen.dart';
import 'package:provider/provider.dart';
import 'models/connection.dart';
import 'models/utilities.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized;
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  CustomColors.init();

  await Hive.initFlutter();
  Hive.registerAdapter(TransactionAdapter());
  await Hive.openBox<Transaction>('mainStorage');
  await Hive.openBox<Transaction>('postStorage');
  await Hive.openBox<Transaction>('patchStorage');
  await Hive.openBox<Transaction>('delStorage');
  await Hive.openBox('utils');

  // await Hive.box<Transaction>('mainStorage').clear();
  // await Hive.box<Transaction>('postStorage').clear();
  // await Hive.box<Transaction>('patchStorage').clear();
  // await Hive.box<Transaction>('delStorage').clear();
  CurrencyFormatter();
  Connection();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) =>
          TransactionsFilter(), // you can change the storage type here
      child: MaterialApp(
        theme: ThemeData(primarySwatch: CustomColors.darkBlue),
        title: "Monefyte",
        home: const SplashScreen(),
        routes: {
          NewTransactionPage.routeName: (_) => const NewTransactionPage(),
          SettingPage.routeName: (_) => const SettingPage(),
          LoginPage.routeName: (_) => const LoginPage(),
          SignUpPage.routeName: (_) => const SignUpPage(),
        },
      ),
    );
  }
}
