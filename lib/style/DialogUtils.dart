import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Dialogutils {
  static void Showloading(BuildContext context) {
    showDialog(
      context: context,
      builder: (Context) => AlertDialog(
        content: SizedBox(
          height: MediaQuery.of(context).size.height * 0.1,
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }

  static void ShowMessageDialog(
    BuildContext context, {
    required String message,
        String? positiveActionTitle,
        void Function()? positiveActionClick,
        String? negativeActionTitle,
        void Function()? negativeActionClick,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(message),
        actions: [
          if (positiveActionTitle != null)
            TextButton(
              onPressed: positiveActionClick,
              child: Text(positiveActionTitle)),
                if (negativeActionTitle != null)
          TextButton(
            onPressed: negativeActionClick,
            child: Text(negativeActionTitle),
            ),
        ],
      ),
    );
  }
  static void showToast(String message){
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}
