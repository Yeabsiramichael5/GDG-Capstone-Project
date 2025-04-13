import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    try {
      print("Firebase: Attempting to sign in with email: $email");
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("Firebase: Sign in successful for user: ${result.user?.email}");
      return result;
    } catch (e) {
      print("Firebase: Sign in error: $e");
      throw Exception('Failed to sign in: ${e.toString()}');
    }
  }

  // Register with email and password
  Future<UserCredential> createUserWithEmailAndPassword(String email, String password) async {
    try {
      print("Firebase: Attempting to create user with email: $email");
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      print("Firebase: User created successfully: ${userCredential.user?.email}");
      
      // Create user document in Firestore
      await _createUserDocument(userCredential.user!);
      
      return userCredential;
    } catch (e) {
      print("Firebase: User creation error: $e");
      throw Exception('Failed to register: ${e.toString()}');
    }
  }

  // Create user document in Firestore
  Future<void> _createUserDocument(User user) async {
    // Extract username from email (everything before @)
    String username = user.email!.split('@')[0];
    
    try {
      print("Firebase: Creating user document for: ${user.email}");
      await _firestore.collection('users').doc(user.uid).set({
        'email': user.email,
        'username': username,
        'createdAt': FieldValue.serverTimestamp(),
        'displayName': user.displayName ?? username,
        'photoURL': user.photoURL,
      });
      print("Firebase: User document created successfully");
    } catch (e) {
      print("Firebase: Error creating user document: $e");
      // Continue anyway since authentication succeeded
    }
  }

  // Get user data from Firestore
  Future<Map<String, dynamic>?> getUserData() async {
    if (currentUser == null) return null;
    
    try {
      print("Firebase: Fetching user data for: ${currentUser!.email}");
      DocumentSnapshot doc = await _firestore.collection('users').doc(currentUser!.uid).get();
      
      if (doc.exists) {
        print("Firebase: User document exists");
        return doc.data() as Map<String, dynamic>;
      } else {
        print("Firebase: User document does not exist, creating basic data");
        // Return basic user data if document doesn't exist
        return {
          'email': currentUser!.email,
          'username': currentUser!.email!.split('@')[0],
          'displayName': currentUser!.displayName ?? currentUser!.email!.split('@')[0],
        };
      }
    } catch (e) {
      print("Firebase: Error getting user data: $e");
      // Return basic user data from auth if Firestore fails
      return {
        'email': currentUser!.email,
        'username': currentUser!.email!.split('@')[0],
        'displayName': currentUser!.displayName ?? currentUser!.email!.split('@')[0],
      };
    }
  }

  // Sign out
  Future<void> signOut() async {
    print("Firebase: Signing out");
    await _auth.signOut();
    print("Firebase: Sign out complete");
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    print("Firebase: Sending password reset email to: $email");
    await _auth.sendPasswordResetEmail(email: email);
    print("Firebase: Password reset email sent");
  }
}
