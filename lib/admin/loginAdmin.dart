import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../AuthService.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class LoginPage extends StatefulWidget {
  final AuthService _authService = AuthService();

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      // Vérification si l'email est vérifié
      if (user != null) {
        // Récupération des données utilisateur dans Firestore
        String uid = user.uid;
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

        if (userDoc.exists) {
          String role = userDoc['role'];
          print('Utilisateur trouvé dans Firestore: $role');

          // Si l'utilisateur est un admin, on ne vérifie pas son email
          if (role == 'admin') {
            // Ne pas envoyer de vérification d'email et rediriger vers l'interface admin
            Get.offNamed('/History');
          } else if (!user.emailVerified) {
            // Si ce n'est pas un admin et que l'email n'est pas vérifié
            Get.snackbar(
              "Vérification d'email requise",
              "Veuillez vérifier votre email avant de vous connecter.",
              snackPosition: SnackPosition.BOTTOM,
            );
            // Renvoyer l'email de vérification
            await user.sendEmailVerification();
            await FirebaseAuth.instance.signOut(); // Déconnexion pour éviter la connexion avec un compte non vérifié
          } else {
            // Si l'email est vérifié, rediriger vers l'interface utilisateur
            Get.offNamed('/userDashboard');
          }
        } else {
          print('Utilisateur non trouvé dans Firestore');
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('Aucun utilisateur trouvé pour cet email.');
      } else if (e.code == 'wrong-password') {
        print('Mot de passe incorrect.');
      } else {
        print('Erreur lors de la connexion: ${e.message}');
      }
    } catch (e) {
      print('Erreur inconnue: $e');
    }
  }

  void _login() async {
    setState(() {
      _isLoading = true;
    });

    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      // Connexion de l'utilisateur avec l'email et le mot de passe
      UserCredential? userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential != null) {
        User? user = userCredential.user;

        if (user != null) {
          // Récupération des données utilisateur depuis Firestore
          DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

          if (userDoc.exists) {
            String role = userDoc['role'];

            // Si l'utilisateur est un admin, on le redirige directement sans vérifier son email
            if (role == 'admin') {
              Get.offNamed('/History'); // Redirection vers la page d'administration
            } else {
              // Si ce n'est pas un admin et que l'email n'est pas vérifié
              if (!user.emailVerified) {
                Get.snackbar(
                  "Erreur",
                  "Veuillez vérifier votre e-mail avant de vous connecter.",
                  snackPosition: SnackPosition.BOTTOM,
                );

                await user.sendEmailVerification(); // Envoie de l'email de vérification
                await FirebaseAuth.instance.signOut(); // Déconnexion de l'utilisateur
                setState(() {
                  _isLoading = false;
                });
                return;
              } else {
                Get.offNamed('/userDashboard'); // Redirection vers le tableau de bord de l'utilisateur
              }
            }
          } else {
            Get.snackbar(
              "Erreur",
              "Utilisateur non trouvé dans Firestore.",
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        } else {
          Get.snackbar(
            "Erreur",
            "Problème de connexion à l'utilisateur.",
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else {
        Get.snackbar(
          "Erreur",
          "Échec de la connexion. Vérifiez votre email et mot de passe.",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } on FirebaseAuthException catch (e) {
      // Gestion des erreurs liées à FirebaseAuth
      if (e.code == 'user-not-found') {
        Get.snackbar(
          "Erreur",
          "Aucun utilisateur trouvé avec cet email.",
          snackPosition: SnackPosition.BOTTOM,
        );
      } else if (e.code == 'wrong-password') {
        Get.snackbar(
          "Erreur",
          "Mot de passe incorrect.",
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          "Erreur",
          "Erreur inconnue: ${e.message}",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }

    setState(() {
      _isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(  // Wrap the entire body in SingleChildScrollView
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50.0),
            Text(
              'Welcome back 👋!',
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Glad to see you, Again!',
              style: TextStyle(
                fontSize: 24.0,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 60.0),
            // Email Input
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Enter your email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            // Password Input
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Enter your password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                suffixIcon: Icon(Icons.visibility_off),
              ),
            ),
            SizedBox(height: 8.0),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // Forgot password logic
                },
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            SizedBox(height: 24.0),
            // Login Button
            SizedBox(
              width: double.infinity,
              height: 50.0,
              child: ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF00C4B4), // Custom color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                  'Login',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
