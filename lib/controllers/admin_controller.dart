import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:zenbyte/Screens/role_selection_screen.dart';
import '../services/auth_service.dart';

class AdminController extends GetxController {
  final AuthService _authService = AuthService();

  Future<User?> signInWithEmailPassword(String email, String password) async {
    return await _authService.signInWithEmailPassword(email, password);
  }

  void signOut() async {
    await _authService.signOut();
    Get.offAll(() => RoleSelectionScreen()); // Redirect to Role Selection Screen
  }
}
