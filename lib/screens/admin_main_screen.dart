import 'package:flutter/material.dart';
import 'package:zenbyte/widgets/admin_drawer.dart';
import 'dashboard.dart';

class AdminHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Home'),
      ),
      drawer: AdminDrawer(),
      body: AdminDashboardScreen(), // Default screen for admin
    );
  }
}
