import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 50), // To move the content down a bit
            // Welcome image at the top
            Center(
              child: Image.asset(
                'assets/images/welcome_image.png', // Use your image path
                height: 200, // Adjust the height as needed
              ),
            ),
            SizedBox(height: 40),
            // Welcome text with emoji
            Center(
              child: Text(
                'Welcome 👋!', // Wave emoji in text
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            // Filled button for "Login"
            ElevatedButton(
              onPressed: () {
                Get.toNamed('/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF00C2C2), // Button background color (matches the image)
                padding: EdgeInsets.symmetric(vertical: 15), // Adjust button height
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Login',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white, // Button text color
                ),
              ),
            ),
            SizedBox(height: 16),
            // Outlined button for "Register"
            OutlinedButton(
              onPressed: () {
                Get.toNamed('/register');
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Color(0xFF00C2C2), width: 2), // Border color
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Register',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF00C2C2), // Text color matching border
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
