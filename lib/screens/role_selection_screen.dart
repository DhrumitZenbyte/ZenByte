import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoleSelectionScreen extends StatelessWidget {
  Future<void> _setUserRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userRole', role);
  }

  void _navigateToLogin(String role) {
    _setUserRole(role);
    if (role == 'admin') {
      Get.toNamed('/adminLogin');
    } else if (role == 'freelancer') {
      Get.toNamed('/freelancerLogin');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Role'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => _navigateToLogin('admin'),
              child: Text('Admin'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _navigateToLogin('freelancer'),
              child: Text('Freelancer'),
            ),
          ],
        ),
      ),
    );
  }
}
