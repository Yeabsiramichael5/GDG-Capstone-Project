import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase_service.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  FirebaseService? _firebaseService;
  
  bool _isLoading = false;
  String? _error;
  Map<String, dynamic>? _userData;
  bool _isUsingFirebase = false;
  
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _isUsingFirebase ? 
      (_firebaseService?.currentUser != null) : 
      (_userData != null);
  User? get firebaseUser => _firebaseService?.currentUser;
  Map<String, dynamic>? get userData => _userData;
  bool get isUsingFirebase => _isUsingFirebase;
  
  // Get username for display
  String get username {
    if (_userData != null && _userData!.containsKey('username')) {
      return _userData!['username'];
    }
    return firebaseUser?.email?.split('@')[0] ?? 'User';
  }
  
  // Constructor
  AuthProvider({bool firebaseInitialized = false}) {
    _isUsingFirebase = firebaseInitialized;
    
    if (_isUsingFirebase) {
      try {
        _firebaseService = FirebaseService();
        print("Firebase service initialized successfully");
        
        // Listen to auth state changes if Firebase is available
        _firebaseService?.authStateChanges.listen((User? user) {
          print("Auth state changed: user = ${user?.email}");
          if (user != null) {
            _fetchUserData();
          } else {
            _userData = null;
          }
          notifyListeners();
        });
      } catch (e) {
        print("Firebase service initialization failed: $e");
        _isUsingFirebase = false;
      }
    } else {
      print("Using demo mode without Firebase");
    }
  }
  
  // Fetch user data
  Future<void> _fetchUserData() async {
    if (_isUsingFirebase && _firebaseService != null) {
      try {
        _userData = await _firebaseService!.getUserData();
        print("User data fetched: $_userData");
      } catch (e) {
        print("Error fetching user data: $e");
        // Create basic user data if Firestore fetch fails
        if (firebaseUser != null) {
          _userData = {
            'email': firebaseUser!.email,
            'username': firebaseUser!.email!.split('@')[0],
          };
        }
      }
    }
    notifyListeners();
  }
  
  // Sign in with email and password
  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      print("Attempting to sign in with email: $email");
      if (_isUsingFirebase && _firebaseService != null) {
        await _firebaseService!.signInWithEmailAndPassword(email, password);
        await _fetchUserData();
        print("Firebase sign in successful");
      } else {
        // Fallback to fake login for demo
        _userData = {
          'email': email,
          'username': email.split('@')[0],
        };
        print("Demo mode: Simulated sign in successful");
      }
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      print("Sign in error: $e");
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
  
  // Register with email and password
  Future<bool> createUserWithEmailAndPassword(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      print("Attempting to create user with email: $email");
      if (_isUsingFirebase && _firebaseService != null) {
        await _firebaseService!.createUserWithEmailAndPassword(email, password);
        await _fetchUserData();
        print("Firebase registration successful");
      } else {
        // Fallback to fake registration for demo
        _userData = {
          'email': email,
          'username': email.split('@')[0],
        };
        print("Demo mode: Simulated registration successful");
      }
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      print("Registration error: $e");
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
  
  // Sign out
  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      if (_isUsingFirebase && _firebaseService != null) {
        await _firebaseService!.signOut();
        print("Firebase sign out successful");
      }
      
      // Always clear user data
      _userData = null;
    } catch (e) {
      print("Sign out error: $e");
      _error = e.toString();
    }
    
    _isLoading = false;
    notifyListeners();
  }
  
  // Reset password
  Future<bool> resetPassword(String email) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      print("Attempting to reset password for email: $email");
      if (_isUsingFirebase && _firebaseService != null) {
        await _firebaseService!.resetPassword(email);
        print("Firebase password reset email sent");
      } else {
        // Just simulate success for demo
        await Future.delayed(const Duration(seconds: 1));
        print("Demo mode: Simulated password reset");
      }
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      print("Password reset error: $e");
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
  
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
