import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'auth_service.dart';
import 'chat_page.dart';
import 'Drawer/drawer.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<DocumentSnapshot>? users; // List of users

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  // Fetch users from Firestore
  Future<void> fetchUsers() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('Users').get();
      setState(() {
        users = snapshot.docs;
      });
    } catch (error) {
      if (kDebugMode) {
        print("Error fetching users: $error");
      }
    }
  }

  // Log out a user by setting their loggedIn status to false
  Future<void> logoutUser(String userId) async {
    try {
      await _firestore.collection('Users').doc(userId).update({'loggedIn': false});
      if (kDebugMode) {
        print("User logged out successfully");
      }
    } catch (error) {
      if (kDebugMode) {
        print("Error logging out user: $error");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text("Error occurred"));
        }

        if (!snapshot.hasData) {
          return const Center(child: Text("No user logged in"));
        }

        User? user = snapshot.data;

        return Scaffold(
          backgroundColor: Colors.pinkAccent.shade400,
          appBar: AppBar(
            backgroundColor: Colors.brown,
            foregroundColor: Colors.white,
            title: const Center(child: Text("Home",style: TextStyle(fontSize: 36,fontWeight: FontWeight.bold),)),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  bool? confirmLogout = await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Confirm Logout"),
                      content: const Text("Are you sure you want to log out?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text("Logout"),
                        ),
                      ],
                    ),
                  );

                  if (confirmLogout == true) {
                    await _authService.signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(onTap: () {}),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
          drawer: const MyDrawer(),
          body: users == null
              ? const Center(child: CircularProgressIndicator())
              : users!.isEmpty
              ? const Center(child: Text("No users found"))
              : ListView.builder(
            itemCount: users!.length,
            itemBuilder: (context, index) {
              var userData = users![index].data() as Map<String, dynamic>;
              String userId = users![index].id;
              String userEmail = userData['email'];
              bool loggedIn = userData['loggedIn'] ?? true;

              // Avoid displaying the currently logged-in user
              if (userEmail == user?.email) {
                return const SizedBox.shrink();
              }

              return ListTile(
                title: Text(userEmail),
                leading: const Icon(Icons.person),
                trailing: IconButton(
                  icon: loggedIn
                      ? const Icon(Icons.logout, color: Colors.red)
                      : const Icon(Icons.check, color: Colors.green),
                  onPressed: () {
                    if (loggedIn) {
                      logoutUser(userId);
                    }
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatPage(
                        recieverEmail: userEmail,
                        receiverID:  userData['uid'], receiverEmail: '',
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
