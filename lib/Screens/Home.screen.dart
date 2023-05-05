import 'package:flutter/material.dart';
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
    );
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
