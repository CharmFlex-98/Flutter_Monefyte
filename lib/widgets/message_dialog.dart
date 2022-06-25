import 'package:flutter/material.dart';

class MessageDialog extends StatelessWidget {
  final String title;
  final String message;
  final String firstOption;
  final String secondOption;

  const MessageDialog(
      {required this.title,
      required this.message,
      this.firstOption = "No",
      this.secondOption = "Yes",
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.red),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 20,
          ),
          firstOption == "No" ? const Text("Continue?") : const SizedBox(),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop([false, context]);
                  },
                  child: Text(firstOption)),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop([true, context]);
                  },
                  child: Text(secondOption)),
            ],
          )
        ],
      ),
    );
  }
}
