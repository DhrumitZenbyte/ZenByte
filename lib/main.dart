import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zenbyte/Screens/admin_login.dart';
import 'package:zenbyte/Screens/freelancer_dashboard.dart';
import 'package:zenbyte/Screens/freelancer_login.dart';
import 'package:zenbyte/Screens/role_selection_screen.dart';
import 'package:zenbyte/screens/admin_main_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyDlViGPb0NsEri9ipDjXSEkgRT5aU46Jig',
        appId: '1:510841256632:android:ba429823a83d197ea1d24d',
        messagingSenderId: '510841256632',
        projectId: 'zenbyte-423ac',
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<String?> _getStoredUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userRole');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getStoredUserRole(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            home: Center(child: CircularProgressIndicator()),
          );
        }

        String? userRole = snapshot.data;

        Widget homeScreen;
        if (userRole == 'admin') {
          homeScreen = AdminHomeScreen();
        } else if (userRole == 'freelancer') {
          homeScreen = FreelancerDashboard(freelancerId: 'yourFreelancerId'); // Replace with actual ID
        } else {
          homeScreen = RoleSelectionScreen();
        }

        return GetMaterialApp(
          home: homeScreen,
          routes: {
            '/adminLogin': (_) => AdminLoginScreen(),
            '/freelancerLogin': (_) => FreelancerLoginScreen(),
          },
        );
      },
    );
  }
}