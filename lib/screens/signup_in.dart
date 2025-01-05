import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quizz_app/screens/avatar_ipload_page.dart';

import 'package:quizz_app/screens/quizz_page.dart';

class SignInSignUpScreen extends StatefulWidget {
  @override
  _SignInSignUpScreenState createState() => _SignInSignUpScreenState();
}

class _SignInSignUpScreenState extends State<SignInSignUpScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isSignUp = false;

  Future<void> _signInSignUp() async {
    try {
      if (_isSignUp) {
        // Perform sign-up
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Navigate to avatar selection after successful sign-up
        await _navigateToAvatarSelection(userCredential.user);
      } else {
        // Perform sign-in
        await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Navigate to quiz page after successful login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => QuizzPage()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  Future<void> _navigateToAvatarSelection(User? user) async {
    if (user != null) {
      // Navigate to the Avatar Selection Page
      String? selectedAvatar = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AvatarSelectionPage()),
      );

      if (selectedAvatar != null) {
        // Set avatar URL to Firebase Authentication
        await user.updatePhotoURL(selectedAvatar);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Avatar updated successfully!')),
        );

        // Navigate to the quiz page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => QuizzPage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isSignUp ? "Sign Up" : "Sign In"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/quiz_logo.png',
                height: 150,
              ),
              SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _signInSignUp,
                child: Text(_isSignUp ? "Sign Up" : "Sign In"),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isSignUp = !_isSignUp;
                  });
                },
                child: Text(_isSignUp
                    ? "Already have an account? Sign In"
                    : "Don't have an account? Sign Up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
