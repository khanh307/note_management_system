import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _HomePage(),
    );
  }
}

class _HomePage extends StatefulWidget {
  const _HomePage({Key? key}) : super(key: key);

  @override
  State<_HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage> {
  var _title = 'Dashboard Form';
  // var _widget = const NoteScreen();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_title),
        ),
        // body: _widget,
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                  accountName: const Text('Note Management System'), accountEmail: const Text('abc@gmail.com'),
                currentAccountPicture: CircleAvatar(
                  child: ClipOval(child: Image.asset('images/profile.png'),),
                ),
                decoration: const BoxDecoration(
                  color: Colors.blue,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Home'),
                onTap: () {
                  setState(() {
                    _title = 'Dashboard Form';
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Category'),
                onTap: () {
                  setState(() {
                    _title = 'Category Form';
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.video_collection_rounded),
                title: const Text('Priority'),
                onTap: () {
                  setState(() {
                    _title = 'Priority Form';
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.restart_alt),
                title: const Text('Status'),
                onTap: () {
                  setState(() {
                    _title = 'Status Form';
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.note),
                title: const Text('Note'),
                onTap: () {
                  setState(() {
                    _title = 'Note Form';
                    // _widget = const NoteScreen();
                  });
                },
              ),
              const Divider(),
              Container(
                margin: const EdgeInsets.all(15),
                child: const Text('Account'),
              ),
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Edit Profile'),
                onTap: () {
                  setState(() {
                    _title = 'Edit Profile Form';
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.send),
                title: const Text('Change password'),
                onTap: () {
                  setState(() {
                    _title = 'Change password Form';
                  });
                },
              ),
            ],
          ),
        ));
  }
}
