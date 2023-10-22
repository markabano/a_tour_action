import 'package:a_tour_action/widgets/adminDrawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminAccountsScreen extends StatefulWidget {
  const AdminAccountsScreen({super.key});

  @override
  State<AdminAccountsScreen> createState() => _AdminAccountsScreenState();
}

class _AdminAccountsScreenState extends State<AdminAccountsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Accounts'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('admins').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot ds = snapshot.data!.docs[index];
                      return ListTile(
                        title: Text(ds['name']),
                        subtitle: Text(ds['email']),
                        trailing: IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Delete Admin'),
                                    content: const Text(
                                        'Are you sure you want to delete this admin?'),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Cancel')),
                                      TextButton(
                                          onPressed: () {
                                            FirebaseFirestore.instance
                                                .collection('admins')
                                                .doc(ds.id)
                                                .delete();
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Delete')),
                                    ],
                                  );
                                });
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      drawer: AdminDrawer(),
    );
  }
}
