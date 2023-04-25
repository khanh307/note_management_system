// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'home',
      home: BuildHome(),
    );
  }
}

class BuildHome extends StatefulWidget {
  const BuildHome({super.key});

  @override
  State<BuildHome> createState() => _BuildHomeState();
}

class _BuildHomeState extends State<BuildHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: const Text('Succesfully', style: TextStyle(fontSize: 40),),
      ),
    );
  }
}