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

  String bmiCategory(double bmi) {
    if (bmi <= 0) return "N/A";
    if (bmi < 18.5) return "Underweight";
    if (bmi < 25) return "Normal";
    if (bmi < 30) return "Overweight";
    return "Obese";
  }

  Color bmiColor(double bmi) {
    if (bmi <= 0) return Colors.grey;
    if (bmi < 18.5) return Colors.orange;
    if (bmi < 25) return Colors.green;
    if (bmi < 30) return Colors.deepOrange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Account"),
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
            return const Center(child: Text("Failed to load user data"));
          }

          final data = snapshot.data!.data()!;
          final username = data['UserName'] ?? "N/A";
          final email = data['Email'] ?? "N/A";
          final phone = data['Phone'] ?? "N/A";
          final height = double.tryParse(data['Height']?.toString() ?? "") ?? 0;
          final weight = double.tryParse(data['Weight']?.toString() ?? "") ?? 0;
          final bmi = calculateBMI(weight, height);
          final gender = data['Gender'] ?? "N/A";
          final goal = data['Goal'] ?? "N/A";

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Profile header
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.blue.shade100,
                        child: const Icon(Icons.person, size: 80, color: Colors.white),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        username,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        email,
                        style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Info grid
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  buildInfoCard(Icons.phone, "Phone", phone),
                  buildInfoCard(Icons.height, "Height", "${height.toStringAsFixed(1)} cm"),
                  buildInfoCard(Icons.monitor_weight, "Weight", "${weight.toStringAsFixed(1)} kg"),
                  buildInfoCard(Icons.person_outline, "Gender", gender),
                  buildInfoCard(Icons.flag, "Goal", goal),
                ],
              ),

              const SizedBox(height: 20),

              // BMI card
              Card(
                color: bmiColor(bmi).withOpacity(0.1),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Text("BMI",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Text(
                        bmi.toStringAsFixed(2),
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: bmiColor(bmi),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        bmiCategory(bmi),
                        style: TextStyle(
                          fontSize: 18,
                          color: bmiColor(bmi),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildInfoCard(IconData icon, String title, String value) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width / 2) - 24,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, size: 28, color: Colors.blueAccent),
              const SizedBox(height: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(fontSize: 15, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
