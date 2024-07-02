import 'package:flutter/material.dart';
import 'package:smart_home_application/models/user.dart';
import 'package:smart_home_application/models/user/views/login.dart';
import 'package:smart_home_application/models/user/views/profile.dart';
import 'package:smart_home_application/models/user/views/sign_up.dart';
import 'package:smart_home_application/services/auth.dart';
import 'package:smart_home_application/views/shared_screens/home_page.dart';
import 'package:smart_home_application/views/shared_screens/get_started.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<MyUser?>.value(
      value: authService().user,
      initialData: null,
      child: MaterialApp(
        home: GetStarted(),
        debugShowCheckedModeBanner: false,
        routes: {
          'sign_up': (context) => const sign_up(),
          'login': (context) => const login_screen(),
          'home': (context) => const home_page(),
          'profile': (context) => const profile(),
        },
      ),
    );
  }
}
