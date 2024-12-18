import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential?> loginUser(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print('Erreur de connexion: $e');
      return null;
    }
  }

  Future<DocumentSnapshot?> getUserData(String uid) async {
    try {
      return await _firestore.collection('users').doc(uid).get();
    } catch (e) {
      print('Erreur lors de la récupération des données: $e');
      return null;
    }
  }

  Future<void> registerUser(String email, String password, String role) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'email': email,
        'role': role,
      });
    } catch (e) {
      print('Erreur lors de l\'inscription: $e');
    }
  }
}