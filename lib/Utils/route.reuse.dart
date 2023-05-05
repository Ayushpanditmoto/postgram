import 'package:flutter/material.dart';

import '../Screens/export.allscreen.dart';

class MyRouter {
  static const String home = '/';
  static const String auth = '/auth';
  static const String comment = '/comment';
  static const String createPost = '/createpost';
  static const String profile = '/profile';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case MyRouter.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case MyRouter.auth:
        return MaterialPageRoute(builder: (_) => const AuthScreen());
      // case MyRouter.comment:
      //   return MaterialPageRoute(
      //       builder: (_) => const Comments(
      //             snaps: {},
      //           ));
      case MyRouter.createPost:
        return MaterialPageRoute(builder: (_) => const CreatePost());
      // case MyRouter.profile:
      //   return MaterialPageRoute(
      //       builder: (_) => const ProfileScreen(
      //             uid: '',
      //           ));

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
