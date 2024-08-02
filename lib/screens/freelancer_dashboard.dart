import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'role_selection_screen.dart'; // Import the RoleSelectionScreen

class FreelancerDashboard extends StatelessWidget {
  final String freelancerId;

  FreelancerDashboard({required this.freelancerId});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Fetch projects assigned to the freelancer by looking up their assigned projects
  Stream<List<Map<String, dynamic>>> _getAssignedProjects() {
    return _firestore
        .collection('freelancers')
        .doc(freelancerId)
        .snapshots()
        .asyncMap((docSnapshot) async {
      if (!docSnapshot.exists) {
        print('Freelancer document does not exist.');
        return [];
      }

      List<String> assignedProjectIds = List<String>.from(docSnapshot.data()?['assignedProjects'] ?? []);
      print('Assigned Project IDs: $assignedProjectIds');

      if (assignedProjectIds.isEmpty) {
        return [];
      }

      List<Map<String, dynamic>> projects = [];
      for (String projectId in assignedProjectIds) {
        final projectSnapshot = await _firestore.collection('projects').doc(projectId).get();
        if (projectSnapshot.exists) {
          projects.add(projectSnapshot.data() as Map<String, dynamic>);
        } else {
          print('Project document with ID $projectId does not exist.');
        }
      }

      print('Fetched Projects: $projects');
      return projects;
    });
  }

  // Method to handle user logout
  Future<void> _logout() async {
    try {
      await _auth.signOut();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('userRole'); // Remove user role from SharedPreferences
      Get.offAll(() => RoleSelectionScreen()); // Navigate to RoleSelectionScreen after logout
    } catch (e) {
      Get.snackbar('Logout Error', 'An error occurred while logging out. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Freelancer Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _getAssignedProjects(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No projects assigned.'));
          }

          final projects = snapshot.data!;

          return ListView.builder(
            itemCount: projects.length,
            itemBuilder: (context, index) {
              final project = projects[index];
              final projectName = project['name'] ?? 'No Name';
              final startDate = project['startDate'] ?? 'No Date';

              return Card(
                elevation: 4.0,
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(projectName),
                  subtitle: Text('Start Date: $startDate'),
                  onTap: () {
                    // Handle project tap if needed
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
