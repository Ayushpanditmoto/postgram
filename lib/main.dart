import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:postgram/Screens/export.allscreen.dart';
import 'package:postgram/Utils/route.reuse.dart';
import 'package:provider/provider.dart';
import 'Providers/auth.provider.dart';
import 'Providers/theme.provider.dart';
import 'Utils/theme.data.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => Auth()),
      ],
      child: Builder(builder: (BuildContext context) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        final authProvider = Provider.of<Auth>(context);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "PostGram",
          theme: CustomTheme.lightTheme(),
          darkTheme: CustomTheme.darkTheme(),
          themeMode: themeProvider.themeMode,
          home: authProvider.user != null
              ? const HomeScreen()
              : const AuthScreen(),
          // initialRoute: MyRouter.auth,
          onGenerateRoute: MyRouter.generateRoute,
        );
      }),
    );
  }
}
