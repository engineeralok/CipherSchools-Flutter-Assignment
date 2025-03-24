import 'package:cipherschools_flutter_assignment/prov/navigation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user;
  UserModel? userModel;
  bool isLoading = false;
  bool isSignUpLoading = false;
  bool isLoginLoading = false;
  bool isGoogleSignInLoading = false;
  String? errorMessage;

  AuthProvider() {
    checkCurrentUser();
  }

  Future<void> checkCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('user_id');

    if (userId != null) {
      try {
        final docSnapshot =
            await _firestore.collection('users').doc(userId).get();
        if (docSnapshot.exists) {
          userModel = UserModel.fromMap(docSnapshot.data()!);
          user = _auth.currentUser;
          notifyListeners();
        }
      } catch (e) {
        debugPrint('Error fetching user data: $e');
      }
    }
  }

  Future<void> _storeUserData(User user) async {
    final userModel = UserModel(
      uid: user.uid,
      name: user.displayName ?? '',
      email: user.email ?? '',
      photoUrl: user.photoURL,
    );

    await _firestore.collection('users').doc(user.uid).set(userModel.toMap());
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', user.uid);
    this.userModel = userModel;
  }

  Future<bool> signUpWithEmailAndPassword() async {
    try {
      isSignUpLoading = true;
      notifyListeners();
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      user = userCredential.user;
      await user?.updateDisplayName(nameController.text.trim());
      isSignUpLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isSignUpLoading = false;
      debugPrint(e.toString());
      errorMessage = 'Sign up failed. Please try again.';
      notifyListeners();
      return false;
    }
  }

  Future<bool> signInWithEmailAndPassword() async {
    try {
      isLoginLoading = true;
      notifyListeners();
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      user = userCredential.user;
      isLoginLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoginLoading = false;
      debugPrint(e.toString());
      errorMessage = 'Login failed. Please try again.';
      notifyListeners();
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      isGoogleSignInLoading = true;
      notifyListeners();
      await _auth.setLanguageCode("en");

      await _googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        debugPrint("Google Sign-In cancelled by user.");
        isGoogleSignInLoading = false;
        notifyListeners();
        return false;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      user = userCredential.user;
      if (user == null) {
        debugPrint("Google Sign-In failed: User is null.");
        isGoogleSignInLoading = false;
        notifyListeners();
        return false;
      }

      await _storeUserData(user!);
      debugPrint("Google Sign-In Successful: ${user!.email}");

      isGoogleSignInLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Google Sign-In Error: $e");
      isGoogleSignInLoading = false;
      errorMessage = "Google Sign-In failed. Please try again.$e";
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut(NavigationProvider navigationProvider) async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    user = null;
    userModel = null;
    Future.microtask(() {
      navigationProvider.setCurrentIndex(0);
    });
    notifyListeners();
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isPasswordVisible = false;
  bool isChecked = false;

  updateControllers() {
    nameController.addListener(_updateButtonState);
    emailController.addListener(_updateButtonState);
    passwordController.addListener(_updateButtonState);
  }

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  void toggleCheckbox(bool? value) {
    isChecked = value ?? false;
    notifyListeners();
  }

  bool get isButtonEnabled {
    return nameController.text.trim().isNotEmpty &&
        emailController.text.trim().isNotEmpty &&
        passwordController.text.trim().isNotEmpty &&
        isChecked;
  }

  void _updateButtonState() {
    notifyListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
