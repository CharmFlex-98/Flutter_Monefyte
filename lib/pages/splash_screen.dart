import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:my_expenses_manager/pages/homepage.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  // @override
  // void initState() {
  //   Future.delayed(Duration(seconds: 2), () async {
  //     Navigator.pushReplacementNamed(context, HomePage.routeName);
  //   });

  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: 'assets/splash_icon.png',
      nextScreen: const HomePage(),
      splashTransition: SplashTransition.fadeTransition,
      splashIconSize: (MediaQuery.of(context).size.height -
          MediaQuery.of(context).padding.top),
      animationDuration: const Duration(milliseconds: 1500),
      pageTransitionType: PageTransitionType.fade,
    );
  }
}
