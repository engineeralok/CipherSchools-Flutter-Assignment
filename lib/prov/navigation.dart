import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NavigationProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;
  bool get isUserLoggedIn => _auth.currentUser != null;

  void setCurrentIndex(int index) {
    if (_currentIndex != index) {
      _currentIndex = index;
      notifyListeners();
    }
  }
}
