import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HelperWidget {
  static void showToast(String message, [BuildContext? context]) {
    if (context == null) {
      Fluttertoast.showToast(
        msg: message,
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.red.shade100,
        textColor: Colors.black,
        fontSize: 16.0,
      );
    } else {
      FToast fToast = FToast()..init(context);
      fToast.showToast(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
            color: Colors.red.shade100,
          ),
          child: Text(
            message,
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),
        ),
        gravity: ToastGravity.CENTER,
        toastDuration: const Duration(seconds: 10),
      );
    }
  }

  //hight light occurrentces
  static List<TextSpan> highlightOccurrences(String text, String query) {
    final List<TextSpan> spans = [];
    final String lowercaseText = text.toLowerCase();
    final String lowercaseQuery = query.toLowerCase();

    int lastIndex = 0;
    int index = lowercaseText.indexOf(lowercaseQuery);

    while (index != -1) {
      spans.add(TextSpan(text: text.substring(lastIndex, index)));
      spans.add(TextSpan(text: text.substring(index, index + query.length), style: const TextStyle(fontWeight: FontWeight.bold)));
      lastIndex = index + query.length;
      index = lowercaseText.indexOf(lowercaseQuery, lastIndex);
    }

    spans.add(TextSpan(text: text.substring(lastIndex, text.length)));

    return spans;
  }
}
