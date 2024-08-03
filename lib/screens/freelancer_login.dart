import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'freelancer_dashboard.dart';

class FreelancerLoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _setUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userRole', 'freelancer');
  }

  void _login() async {
    // Simulate login and fetch freelancer email
    final freelancerEmail = emailController.text; // Use email instead of ID

    // Set user role in shared preferences
    await _setUserRole();

    // Navigate to FreelancerDashboard with the email
    Get.offAll(() => FreelancerDashboard(freelancerEmail: freelancerEmail));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Freelancer Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
