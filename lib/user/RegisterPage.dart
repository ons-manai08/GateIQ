import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../AuthService.dart'; // Pour manipuler le fichier image

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class RegisterPage extends StatefulWidget {
  final AuthService _authService = AuthService();

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  bool _isLoading = false;
  File? _imageFile;  // Variable pour stocker l'image sélectionnée

  final ImagePicker _picker = ImagePicker();  // Instance de ImagePicker

  // Méthode pour choisir l'image
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery); // Sélectionner depuis la galerie
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // Méthode pour télécharger l'image dans Firebase Storage (si vous en avez besoin)
  Future<String?> _uploadImage(File imageFile) async {
    try {
      // Vous pouvez uploader l'image dans Firebase Storage ou sur votre serveur
      // Exemple avec Firebase Storage :
      // final storageRef = FirebaseStorage.instance.ref().child('user_images/${DateTime.now().millisecondsSinceEpoch}');
      // final uploadTask = storageRef.putFile(imageFile);
      // final downloadUrl = await uploadTask.then((snapshot) => snapshot.ref.getDownloadURL());
      // return downloadUrl;

      // Si vous n'utilisez pas Firebase Storage, vous pouvez simplement retourner un chemin d'URL temporaire
      return 'https://example.com/temp_image_url';  // Retour d'un chemin fictif
    } catch (e) {
      print("Erreur lors du téléchargement de l'image: $e");
      return null;
    }
  }

  Future<void> registerUser(String name, String email, String password, String role) async {
    try {
      // Créer un utilisateur dans Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Envoyer un email de vérification
      User? user = userCredential.user;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification(); // Envoyer l'email de vérification
        print("Email de vérification envoyé.");
      }

      // Récupérer l'UID généré par Firebase pour l'utilisateur
      String? uid = user?.uid;

      // Télécharger l'image si l'utilisateur en a sélectionnée une
      String? imageUrl = _imageFile != null ? await _uploadImage(_imageFile!) : null;

      // Créer un document dans Firestore avec l'UID comme ID de document
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'name': name, // Ajout du nom de l'utilisateur
        'email': email,
        'role': role,
        'imageUrl': imageUrl,  // Enregistrer l'URL de l'image si elle existe
        'password': password, // Il est déconseillé de stocker les mots de passe en clair.
        'createdAt': Timestamp.now(), // Ajout de la date de création
      });

      print("Utilisateur créé avec succès dans Firestore et e-mail de vérification envoyé !");
    } catch (e) {
      print('Erreur lors de l\'inscription: $e');
      Get.snackbar("Erreur", "Échec de l'inscription: ${e.toString()}",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();
      String name = _nameController.text.trim();
      String role = email == 'admin@gmail.com' ? 'admin' : 'user';

      await registerUser(name, email, password, role);

      setState(() {
        _isLoading = false;
      });

      Get.snackbar("Succès", "Inscription réussie! Un email de vérification a été envoyé.",
          snackPosition: SnackPosition.BOTTOM);
      Get.offNamed('/login'); // Naviguer vers la page de connexion après l'inscription
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Créer un compte',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _nameController, // Champ pour le nom
                decoration: InputDecoration(
                  labelText: 'Nom',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre nom';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre email';
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Entrez une adresse email valide';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un mot de passe';
                  } else if (value.length < 6) {
                    return 'Le mot de passe doit comporter au moins 6 caractères';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirmer le mot de passe',
                  prefixIcon: Icon(Icons.lock_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez confirmer votre mot de passe';
                  } else if (value != _passwordController.text) {
                    return 'Les mots de passe ne correspondent pas';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              // Bouton pour sélectionner l'image
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Choisir une image'),
              ),
              SizedBox(height: 16),
              // Afficher l'image sélectionnée
              if (_imageFile != null)
                Image.file(_imageFile!, height: 100),
              SizedBox(height: 24),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _register,
                  child: Text('Inscription'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Déjà un compte ?'),
                  TextButton(
                    onPressed: () {
                      Get.toNamed('/login');
                    },
                    child: Text('Se connecter'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
