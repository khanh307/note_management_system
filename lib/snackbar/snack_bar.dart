
import 'package:flutter/material.dart';

void showSnackBar(context, title) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.w400, fontSize: 18),
      ),
      duration: const Duration(seconds: 3),
      backgroundColor: const Color.fromARGB(255, 113, 176, 224),
    ),
  );
}
