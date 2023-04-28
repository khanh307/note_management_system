import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:note_manangement_system/Model/user_model.dart';
import 'package:note_manangement_system/shared_widget/app_drawer.dart';

import '../category/category_screen.dart';

class HomeScreen extends StatelessWidget {
  final UserModel user;

  const HomeScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(
        user: user,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final UserModel user;

  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Dashboard Form'),
          ),
          // body: _widget,
          drawer: AppDrawer(
            user: widget.user,
          )),
    );
  }
}
