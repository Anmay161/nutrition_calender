import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final user = FirebaseAuth.instance.currentUser;

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserData() async {
    if (user == null) throw Exception('No user logged in');
    return FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
  }

  double calculateBMI(double weight, double heightCm) {
    if (heightCm <= 0) return 0;
    double heightM = heightCm / 100;
    return weight / (heightM * heightM);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Account'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Failed to load user data'));
          }

          final data = snapshot.data!.data()!;
          final username = data['UserName'] ?? 'N/A';
          final email = data['Email'] ?? 'N/A';
          final phone = data['Phone'] ?? 'N/A';
          final height = double.tryParse(data['Height']?.toString() ?? '') ?? 0;
          final weight = double.tryParse(data['Weight']?.toString() ?? '') ?? 0;
          final bmi = calculateBMI(weight, height);
          final gender = data['Gender'] ?? 'N/A';
          final goal = data['Goal'] ?? 'N/A';

          return Container(
            margin: const EdgeInsets.all(10),
            alignment: Alignment.center,
            child: ListView(
              children: [
                const CircleAvatar(radius: 100, child: Icon(Icons.person, size: 150)),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.center,
                  child: Text('Username: $username', style: const TextStyle(fontSize: 20)),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.center,
                  child: Text('Email: $email', style: const TextStyle(fontSize: 20)),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.center,
                  child: Text('Phone: $phone', style: const TextStyle(fontSize: 20)),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.center,
                  child: Text('Height: ${height.toStringAsFixed(1)} cm', style: const TextStyle(fontSize: 20)),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.center,
                  child: Text('Weight: ${weight.toStringAsFixed(1)} kg', style: const TextStyle(fontSize: 20)),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.center,
                  child: Text('BMI: ${bmi.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20)),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.center,
                  child: Text('Gender: $gender', style: const TextStyle(fontSize: 20)),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.center,
                  child: Text('Goal: $goal', style: const TextStyle(fontSize: 20)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
