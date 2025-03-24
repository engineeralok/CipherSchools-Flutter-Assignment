import 'package:cipherschools_flutter_assignment/prov/navigation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  User? user;
  bool isLoading = false;
  bool isSignUpLoading = false;
  bool isLoginLoading = false;
  bool isGoogleSignInLoading = false;
  String? errorMessage;

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
    user = null;
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

  AuthProvider() {
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
