import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

class AddFreelancerScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Freelancer'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final email = emailController.text;
                final password = passwordController.text;

                // Create a new user with email and password
                User? newUser = await _authService.createUserWithEmailPassword(email, password);

                if (newUser != null) {
                  // Save Freelancer data in Firestore
                  await _firestoreService.addFreelancer(newUser.uid, {
                    'email': email,
                    'assignedProjects': [],
                  });

                  Get.back();
                }
              },
              child: Text('Add Freelancer'),
            ),
          ],
        ),
      ),
    );
  }
}
