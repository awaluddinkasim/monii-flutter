import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String msg) {
  var snackBar = SnackBar(
    content: Text(msg),
    duration: const Duration(milliseconds: 1500),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
