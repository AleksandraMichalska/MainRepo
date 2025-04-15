import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'log_in.dart'; // Importa la página de LogIn

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _emailController = TextEditingController();
  String _statusMessage = "";

  // Método para enviar el correo de restablecimiento de contraseña
  Future<void> _sendPasswordResetEmail() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );
      setState(() {
        _statusMessage = "Password reset email sent!";
      });
    } catch (e) {
      setState(() {
        _statusMessage = "Failed to send reset email: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Reset Password",
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
      body: Container(
        color: const Color(0xFF2E2E2E),
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.8,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: "Enter your email",
                      labelStyle: TextStyle(color: Color(0xFF5C8374)),
                      prefixIcon: Icon(Icons.email, color: Color(0xFF5C8374)),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF5C8374)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF5C8374)),
                      ),
                    ),
                    style: const TextStyle(color: Color(0xFF5C8374)),
                    cursorColor: const Color(0xFF5C8374), // Cambia el color del cursor
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _sendPasswordResetEmail,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5C8374),
                    ),
                    child: const Text(
                      "Send Reset Email",
                      style: TextStyle(color: Color(0xFF040D12)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _statusMessage,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF5C8374),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LogInPage(),
                        ),
                      );
                    },
                    child: const Text(
                      "Back to Login",
                      style: TextStyle(color: Color(0xFF5C8374)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


