import 'package:flutter/material.dart';
import 'package:mironline/constants/routes.dart';

Future<void> showCustomDialog(
  BuildContext context,
  String title,
  String text,
) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(text),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(loginRoute);
              },
              child: const Text('OK'))
        ],
      );
    },
  );
}
