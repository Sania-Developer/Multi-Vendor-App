import 'package:flutter/cupertino.dart';

class my_alert_dialog {
  static void showMy_Dialog(
      {required BuildContext context,
        required String title,
        required String content,
        required Function() tabNo,
        required Function() tabYes}) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: tabNo,
            child: const Text('No'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: tabYes,
            child: const Text('Yes'),
          )
        ],
      ),
    );
  }
}
