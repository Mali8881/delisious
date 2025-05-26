import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Future<bool> registerWithEmail(String email, String password, String name) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      await FirebaseFirestore.instance.collection('users').doc(cred.user!.uid).set({
        'name': name,
        'email': email,
        'createdAt': Timestamp.now(),
      });

      notifyListeners();
      return true;
    } catch (e) {
      print('Ошибка регистрации: $e');
      return false;
    }
  }

  Future<bool> loginWithEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      notifyListeners();
      return true;
    } catch (e) {
      print('Ошибка входа: $e');
      return false;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    notifyListeners();
  }
}
