//Email format audit function
import 'dart:convert';

import 'package:crypto/crypto.dart';

bool isValidEmail(String email) {
  String pattern =
      r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{0,9}$'; // Format email
  RegExp regex = RegExp(pattern);
  return regex.hasMatch(email) && email.length >= 6 && email.length <= 256;
}

//Password hash function to SHA-256 hash string
String hashPassword(String password) {
  var bytes = utf8.encode(password); 
  var digest = sha256.convert(bytes); 
  return digest.toString();
}

// function check firstname
bool isValidName(String name) {
  RegExp r = RegExp(r'^[a-zA-Z]$');
  return r.hasMatch(name);
}

// function check password
bool isPasswordValid(String password) {
  if (password.length < 6 || password.length > 32) {
    return false;
  }

  final passwordRegex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,32}$');
  return passwordRegex.hasMatch(password);
}



