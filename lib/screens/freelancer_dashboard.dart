import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FreelancerDashboard extends StatelessWidget {
  final String freelancerEmail;

  FreelancerDashboard({required this.freelancerEmail});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch projects assigned to the freelancer by looking up their assigned projects
  Stream<List<Map<String, dynamic>>> _getAssignedProjects() {
    return _firestore
        .collection('freelancers')
        .where('email', isEqualTo: freelancerEmail)
        .snapshots()
        .asyncMap((snapshot) async {
      List<String> assignedProjectIds = [];
      if (snapshot.docs.isNotEmpty) {
        assignedProjectIds = List<String>.from(snapshot.docs.first.data()['assignedProjects'] ?? []);
      }

      List<Map<String, dynamic>> projects = [];
      for (String projectId in assignedProjectIds) {
        final projectSnapshot = await _firestore.collection('projects').doc(projectId).get();
        if (projectSnapshot.exists) {
          projects.add(projectSnapshot.data() as Map<String, dynamic>);
        }
      }
      return projects;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Freelancer Dashboard'),
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
