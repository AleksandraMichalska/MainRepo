import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tresde/Admin/admin_page_bar.dart';
import 'package:tresde/LoginSignup/register.dart';
import 'package:tresde/LoginSignup/resset_password_page.dart';
import 'package:tresde/Shop/main_page_shop.dart';
import 'package:tresde/Shop/not_accepted.dart';
import 'package:tresde/FirebaseFiles/firestore_service.dart';
import '../main_page.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final _auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();
  String _statusMessage = "";
  bool _isPasswordVisible = false;

  Future<void> _logInUser() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (userCredential.user?.emailVerified ?? false) {
        setState(() {
          _statusMessage = "Logged in successfully!";
        });

        final user = userCredential.user;
        if (user != null) {
          bool isAdmin = await _firestoreService.isAdmin(user.uid);
          bool isShop = await _firestoreService.isShopUser(user.uid);

          if (isAdmin) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainPageAdmin()),
            );
          } else if (isShop) {
            bool isAccepted = await _firestoreService.isUserAccepted(user.uid);

            if (isAccepted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MainPageShop()),
              );
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => RequestStatusPage()),
              );
            }
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainPage()),
            );
          }
        }
      } else {
        setState(() {
          _statusMessage = "Please verify your email before logging in.";
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = "Wrong email or password";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2E2E2E),
      appBar: AppBar(
        title: const Text(
          "Log In",
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Color(0xFF000000),
          ),
        ),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF5C8374)),
        backgroundColor: const Color(0xFF5C8374),
      ),
      body: LayoutBuilder(

        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: constraints.maxWidth * 0.9,
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Email input
                      TextField(
                        controller: _emailController,
                        cursorColor: const Color(0xFF93B1A6),
                        style: const TextStyle(color: Color(0xFF93B1A6)),
                        decoration: const InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(color: Color(0xFF5C8374)),
                          prefixIcon: Icon(Icons.email, color: Color(0xFF5C8374)),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF5C8374)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF5C8374)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      // Password input
                      TextField(
                        controller: _passwordController,
                        cursorColor: const Color(0xFF93B1A6),
                        style: const TextStyle(color: Color(0xFF93B1A6)),
                        decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: const TextStyle(color: Color(0xFF5C8374)),
                          prefixIcon: const Icon(Icons.lock, color: Color(0xFF5C8374)),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: const Color(0xFF5C8374),
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF5C8374)),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF5C8374)),
                          ),
                        ),
                        obscureText: !_isPasswordVisible,
                      ),
                      const SizedBox(height: 20.0),

                      ElevatedButton(
                        onPressed: _logInUser,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5C8374),
                        ),
                        child: const Text(
                          "Log In",
                          style: TextStyle(color: Color(0xFF183D3D)),
                        ),
                      ),
                      const SizedBox(height: 16.0),

                      Text(
                        _statusMessage,
                        style: const TextStyle(fontSize: 16, color: Color(0xFF5C8374)),
                      ),

                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterPage(),
                            ),
                          );
                        },
                        child: const Text(
                          "Don't have an account? Register",
                          style: TextStyle(color: Color(0xFF93B1A6)),
                        ),
                      ),

                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ResetPasswordPage(),
                            ),
                          );
                        },
                        child: const Text(
                          "Forgot your password?",
                          style: TextStyle(color: Color(0xFF93B1A6)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
