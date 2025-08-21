import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nutrition_calender/firebase/firebase_options.dart';
// ignore: unused_import
import 'package:nutrition_calender/pages/getting_started.dart';
// ignore: unused_import
import 'package:nutrition_calender/components/home_page.dart';
// ignore: unused_import
import 'package:nutrition_calender/pages/login_page.dart';
// ignore: unused_import
import 'package:nutrition_calender/pages/signin_page.dart';

// ignore: unused_import
import 'package:nutrition_calender/pages/welcome.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nutrition Calendar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
      ),
      home: const WelcomePage(),
    );
  }
}
