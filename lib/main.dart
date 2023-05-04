import 'package:flutter/material.dart';
import 'package:note_manangement_system/category/category_screen.dart';
import 'package:note_manangement_system/homePage/home.dart';
import 'package:note_manangement_system/model/user_model.dart';
import 'package:note_manangement_system/note/note_screen.dart';

import 'login/sign_in_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(user: UserModel(id: 1, email: "abc"),),
    );
  }
}
