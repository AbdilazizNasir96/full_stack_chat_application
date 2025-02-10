import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get the current authenticated user
  Future<User?> getCurrentUser() async {
    User? currentUser = _auth.currentUser;
    return currentUser;  // returns the current user if logged in
  }

  // Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  // Register with email and password
  Future<UserCredential> registerWithEmailAndPassword(String email, String password) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

    // Debug: print to check user registration
    print("User Registered: ${userCredential.user?.uid}");

    // Save user info in a separate document in Firestore
    try {
      await _firestore.collection('Users').doc(userCredential.user!.uid).set(
        {
          'uid': userCredential.user!.uid,
          'email': email,
        },
      );
      print("User data saved to Firestore");  // Debugging statement
    } catch (e) {
      print("Error saving user data to Firestore: $e");
    }

    return userCredential;
  }

  // Sign out
  Future<void> signOut() async {
    return await _auth.signOut();
  }
}
