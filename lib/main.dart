import 'package:firebase_core/firebase_core.dart';
import 'package:xgen/ui/pages/splash_screen.dart';
import 'constants/app_theme.dart';
import 'controllers/app_controller.dart';
import 'controllers/auth_controller.dart';
import 'controllers/user_controller.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/notes_controller.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(final BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (final _) => AppController()),
        ChangeNotifierProvider(create: (final _) => AuthController()),
        ChangeNotifierProvider(create: (final _) => NotesController()),
        ChangeNotifierProvider(create: (final _) => UserController()),
      ],
      child: MaterialApp(
        navigatorKey:navigatorKey ,
        theme: appTheme,
        debugShowCheckedModeBanner: false,
        home:  const SplashScreen(),
      ),
    );
  }
}