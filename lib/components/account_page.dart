import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Account'),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.settings)),
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        alignment: Alignment.center,
        child: ListView(
          children: [
            CircleAvatar(radius: 100, child: Icon(Icons.person, size: 150)),
            SizedBox(height: 10),

            Align(
              alignment: Alignment.center,
              child: Text('Username', style: TextStyle(fontSize: 20)),
            ),
            SizedBox(height: 10),

            Align(
              alignment: Alignment.center,
              child: Text('Age', style: TextStyle(fontSize: 20)),
            ),
            SizedBox(height: 10),

            Align(
              alignment: Alignment.center,
              child: Text('BMI', style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}
