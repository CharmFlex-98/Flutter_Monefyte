import 'package:flutter/material.dart';

class LoadingWidget {
  static Future<void> show(BuildContext context) {
    return showDialog(
        barrierColor: Colors.black26,
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.red,
            ),
          );
        });
  }
}
