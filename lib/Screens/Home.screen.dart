import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:postgram/Screens/export.allscreen.dart';
import 'package:postgram/Services/auth.services.dart';
import 'package:postgram/Utils/route.reuse.dart';
import 'package:provider/provider.dart';

import '../Providers/theme.provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final isDark = theme.themeMode == ThemeMode.dark;
    return Scaffold(
        appBar: AppBar(
          title: searchBar(isDark),
          actions: [
            // Switch(
            //   value: isDark,
            //   onChanged: (value) {
            //     isDark
            //         ? theme.setThemeMode(ThemeMode.light)
            //         : theme.setThemeMode(ThemeMode.dark);
            //   },
            // )
            //Dark mode
            IconButton(
              onPressed: () {
                isDark
                    ? theme.setThemeMode(ThemeMode.light)
                    : theme.setThemeMode(ThemeMode.dark);
              },
              icon: Icon(
                isDark ? Icons.dark_mode : Icons.light_mode,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ],
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
                  AuthMethod().logout();
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
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 20,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    MyRouter.home,
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.home),
              ),
              IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, MyRouter.createPost);
                  },
                  icon: const Icon(Icons.add_box)),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(
                          uid: FirebaseAuth.instance.currentUser!.uid,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.person))
            ],
          ),
        ));
  }

  //Search bar on top
  Widget searchBar(bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[700] : Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: const TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(Icons.search),
          hintText: "Search",
        ),
      ),
    );
  }
}
