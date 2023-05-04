import 'package:flutter/material.dart';
import 'package:postgram/Services/auth.services.dart';
import 'package:postgram/Utils/route.reuse.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                AuthServies.signOut();
                Navigator.pushNamedAndRemoveUntil(
                    context, MyRouter.auth, (route) => false);
              },
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text('Home Screen'),
      ),
    );
  }
}
