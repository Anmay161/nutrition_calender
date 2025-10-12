import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nutrition_calender/firebase/user_model.dart';
import 'package:nutrition_calender/pages/getting_started.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerifyEmailPage extends StatefulWidget {
  String userName, phone, email;
  VerifyEmailPage({
    super.key,
    required this.userName,
    required this.phone,
    required this.email,
  });

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _sendVerificationEmail();
  }

  Future<void> _sendVerificationEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  Future<void> _checkVerification() async {
    setState(() => _isSending = true);
    await FirebaseAuth.instance.currentUser?.reload();
    final user = FirebaseAuth.instance.currentUser;

    if (user != null && user.emailVerified) {
      final newUser = AddUser(
        id: user.uid,
        name: widget.userName,
        email: widget.email,
        phoneNo: widget.phone, 
      );

      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .set(newUser.toJson());
          
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => GettingStarted()),
        );
      }
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Email not verified yet. Please check inbox/spam."),
        ),
      );
    }
    setState(() => _isSending = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verify Email")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "We sent a verification email. Please check your inbox.",
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendVerificationEmail,
              child: const Text("Resend Email"),
            ),
            const SizedBox(height: 20),
            _isSending
                ? const CircularProgressIndicator()
                : ElevatedButton(
                  onPressed: _checkVerification,
                  child: const Text("I Verified, Continue"),
                ),
          ],
        ),
      ),
    );
  }
}
