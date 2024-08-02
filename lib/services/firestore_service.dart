import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addFreelancer(String freelancerId, Map<String, dynamic> freelancerData) async {
    await _db.collection('freelancers').doc(freelancerId).set(freelancerData);
  }

  Future<void> addProject(String adminId, String projectId, Map<String, dynamic> projectData) async {
    await _db.collection('admins').doc(adminId).collection('projects').doc(projectId).set(projectData);
  }

  Future<void> assignProjectToFreelancer(String adminId, String freelancerId, String projectId) async {
    try {
      await _db.collection('admins').doc(adminId).collection('projects').doc(projectId).update({
        'assignedTo': freelancerId,
      });
      print('Project assigned successfully');
    } catch (e) {
      print('Error assigning project: $e');
    }
  }

  Stream<List<Map<String, dynamic>>> getProjects(String freelancerId) {
    return _db.collectionGroup('projects').where('assignedTo', isEqualTo: freelancerId).snapshots().map(
          (snapshot) => snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList(),
    );
  }

  Future<void> updateProjectStatus(String adminId, String projectId, String status) async {
    await _db.collection('admins').doc(adminId).collection('projects').doc(projectId).update({
      'status': status,
    });
  }



  Stream<List<Map<String, dynamic>>> getFreelancers() {
    return _db.collection('freelancers').snapshots().map(
          (snapshot) => snapshot.docs.map((doc) => {
        'id': doc.id,
        'email': doc.data()['email'],
      }).toList(),
    );
  }
}
