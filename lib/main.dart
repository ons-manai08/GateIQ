import 'package:defi_projet/admin/SpacesListPage.dart';
import 'package:defi_projet/admin/UserListPage.dart';
import 'package:defi_projet/user/RegisterPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'WelcomePage.dart';
import 'admin/HistoryPage.dart';
import 'admin/loginAdmin.dart';
import 'user/userDashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyAgqTMgGVBIXgL3cAmAZOtkWFNHFVZwuhQ",
        authDomain: "porte-2ee6a.firebaseapp.com",
        databaseURL: "https://porte-2ee6a-default-rtdb.firebaseio.com",
        projectId: "porte-2ee6a",
        storageBucket: "porte-2ee6a.appspot.com",
        messagingSenderId: "405995799853",
        appId: "1:405995799853:web:6701a690edbcc1454affa4",
      ),
    );
  } catch (e) {
    print("Firebase déjà initialisé : $e");
  }
  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Campus Connect',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      initialRoute: '/welcome',
      getPages: [
        GetPage(name: '/welcome', page: () => WelcomePage()),
        GetPage(name: '/login', page: () => LoginPage()),
        GetPage(name: '/register', page: () => RegisterPage()),
        GetPage(name: '/adminDashboard', page: () => HistoryPage()), // Page admin
        GetPage(name: '/userDashboard', page: () => UserDashboard()),
        GetPage(name: '/History', page: () => HistoryPage()),
        GetPage(name: '/Spaces', page: () => SpacesListPage()), // Page admin
        GetPage(name: '/Users', page: () => UserListPage()),// Page utilisateur
      ],
    );
  }
}
