import 'package:a_tour_action/screens/admin/admin_dashboard_screen.dart';
import 'package:a_tour_action/screens/user/home_screen.dart';
import 'package:a_tour_action/screens/user/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection('admins')
                  .where('uid', isEqualTo: snapshot.data!.uid)
                  .get(),
              builder: (context, adminSnapshot) {
                if (adminSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (adminSnapshot.hasError) {
                  // Handle the error gracefully
                  return Text('Error: ${adminSnapshot.error}');
                } else if (adminSnapshot.hasData &&
                    adminSnapshot.data!.docs.isNotEmpty) {
                  // User is an admin
                  return AdminDashboardScreen();
                } else {
                  // User is not an admin
                  return HomeScreen();
                }
              },
            );
          } else {
            return LoginScreen();
          }
        },
      ),
    );
  }
}
