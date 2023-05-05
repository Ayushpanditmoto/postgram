import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:postgram/Screens/export.allscreen.dart';
import 'package:postgram/Services/auth.services.dart';
import 'package:postgram/Utils/route.reuse.dart';
import 'package:provider/provider.dart';

import '../Components/post.component.dart';
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
                child: Center(child: Text('Postgram')),
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
        body: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 1));
          },
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('confession')
                  .orderBy('datePublished', descending: true)
                  .snapshots(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text('Something went wrong'),
                  );
                } else if (snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('No Confession'),
                  );
                }

                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Post(
                              isAdminCheck: false,
                              snaps: snapshot.data!.docs[index].data(),
                              index: snapshot.data!.docs.length - index - 1,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }),
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
                  //if route is home then do nothing
                  if (ModalRoute.of(context)!.settings.name == MyRouter.home) {
                    return;
                  }

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
