import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:zenbyte/Screens/role_selection_screen.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

class FreelancerController extends GetxController {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  var projects = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchProjects();
  }

  Future<User?> signInWithEmailPassword(String email, String password) async {
    return await _authService.signInWithEmailPassword(email, password);
  }

  void signOut() async {
    await _authService.signOut();
    Get.offAll(() => RoleSelectionScreen()); // Redirect to Role Selection Screen
  }

  void fetchProjects() {
    final user = _authService.getCurrentUser();
    if (user != null) {
      _firestoreService.getProjects(user.uid).listen((projects) {
        this.projects.value = projects;
      });
    }
  }
}
