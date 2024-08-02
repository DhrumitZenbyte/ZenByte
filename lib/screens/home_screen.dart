import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'admin_login.dart';
import 'freelancer_login.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Project Management App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Get.to(() => AdminLoginScreen()),
              child: Text('Admin Login'),
            ),
            ElevatedButton(
              onPressed: () => Get.to(() => FreelancerLoginScreen()),
              child: Text('Freelancer Login'),
            ),
          ],
        ),
      ),
    );
  }
}
