import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:nutrition_calender/pages/login_page.dart';
import 'package:nutrition_calender/pages/navigate_page.dart';
import 'package:nutrition_calender/pages/verification_page.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData) {
          return const LoginPage();
        }
        
        final user = snapshot.data!;
        if (!user.emailVerified) {
          var box = Hive.box('user_data');
          return  VerifyEmailPage(
              userName: box.get('username', defaultValue: ''),
              phone: box.get('phone', defaultValue: ''),
              email: box.get('email'),
            ); 
        }
        // final user = snapshot.data!;
        // logged in and verified
        return const NavigatePage();
      },
    );
  }
}
