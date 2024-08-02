import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zenbyte/screens/add_freelancer.dart';
import '../screens/add_project.dart'; // Ensure this path is correct
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/role_selection_screen.dart';

class AdminDrawer extends StatelessWidget {
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userRole');
    Get.offAll(() => RoleSelectionScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Admin Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text('Add Project'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Get.to(() => AddProjectScreen()); // Navigate to Add Project
            },
          ),
          ListTile(
            leading: Icon(Icons.person_add),
            title: Text('Add Freelancer'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Get.to(() => AddFreelancerScreen()); // Navigate to Add Freelancer
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () async {
              await _logout(); // Handle logout
            },
          ),
        ],
      ),
    );
  }
}
