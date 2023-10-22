import 'package:a_tour_action/screens/admin/admin_accounts_screen.dart';
import 'package:a_tour_action/screens/admin/admin_dashboard_screen.dart';
import 'package:a_tour_action/screens/admin/user_accounts_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminDrawer extends StatefulWidget {
  const AdminDrawer({
    super.key,
  });

  @override
  State<AdminDrawer> createState() => _AdminDrawerState();
}

class _AdminDrawerState extends State<AdminDrawer> {
  String adminName = '';
  String adminEmail = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAdminInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(adminName),
            accountEmail: Text(adminEmail),
          ),
          ListTile(
            title: const Text('Dashboard'),
            leading: const Icon(Icons.dashboard),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AdminDashboardScreen()));
            },
          ),
          ExpansionTile(
            title: const Text('Accounts'),
            leading: const Icon(Icons.manage_accounts),
            childrenPadding: EdgeInsets.only(left: 20),
            children: [
              ListTile(
                leading: const Icon(Icons.admin_panel_settings),
                title: const Text('Admins'),
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AdminAccountsScreen()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Users'),
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UserAccountsScreen()));
                },
              ),
            ],
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
    );
  }

  Future<void> getAdminInfo() async {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    var adminInfo = await FirebaseFirestore.instance
        .collection('admins')
        .doc(firebaseUser!.uid)
        .get();

    setState(() {
      adminName = adminInfo['name'];
      adminEmail = adminInfo['email'];
    });
  }
}
