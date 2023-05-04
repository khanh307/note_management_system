import 'package:flutter/material.dart';
import 'package:note_manangement_system/Model/user_model.dart';
import 'package:note_manangement_system/status/status_screen.dart';

import '../category/category_screen.dart';
import '../homePage/home.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
    required this.user,
  });

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text('Note Management System'),
            accountEmail: Text(user.email!),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.asset('assets/images/profile.png'),
              ),
            ),
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Home'),
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => HomePage(
                        user: user,
                      )));
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Category'),
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => CategoryScreen(
                        user: user,
                      )));
            },
          ),
          ListTile(
              leading: const Icon(Icons.video_collection_rounded),
              title: const Text('Priority'),
              onTap: () {}),
          ListTile(
            leading: const Icon(Icons.restart_alt),
            title: const Text('Status'),
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => StatusScreen(
                        user: user,
                      )));
            },
          ),
          ListTile(
            leading: const Icon(Icons.note),
            title: const Text('Note'),
            onTap: () {},
          ),
          const Divider(),
          Container(
            margin: const EdgeInsets.all(15),
            child: const Text('Account'),
          ),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Edit Profile'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.send),
            title: const Text('Change password'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
