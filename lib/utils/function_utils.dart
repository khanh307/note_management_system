//Email format audit function
import 'dart:convert';

import 'package:crypto/crypto.dart';

bool isValidEmail(String value) {
  String pattern =
      r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$'; // Format email
  RegExp regex = RegExp(pattern);
  return regex.hasMatch(value);
}

//Password hash function to SHA-256 hash string
String hashPassword(String password) {
  var bytes = utf8.encode(password); 
  var digest = sha256.convert(bytes); 
  return digest.toString();
}