import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback? onOkPressed;

  CustomAlertDialog({
    required this.title,
    required this.content,
    this.onOkPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        TextButton(
          child: Text('OK'),
          onPressed: () {
            if (onOkPressed != null) {
              onOkPressed!(); // Call the provided function when OK is pressed
            }
            Navigator.of(context).pop(); // Close the dialog
          },
        ),
      ],
    );
  }
}

void showCustomDialog(BuildContext context, {
  required String title,
  required String content,
  VoidCallback? onOkPressed,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CustomAlertDialog(
        title: title,
        content: content,
        onOkPressed: onOkPressed,
      );
    },
  );
}
