import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tresde/LoginSignup/log_in.dart';
import 'package:tresde/FirebaseFiles/firestore_service.dart';
import 'package:tresde/link_formatter.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _shopNameController = TextEditingController();
  final _shopDescriptionController = TextEditingController();
  final _shopWebsiteController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();
  bool _isShopAccount = false;
  String _statusMessage = "";
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _shopWebsiteController.text = "https://";
  }

  Future<void> _submitRequest() async {
    if (_passwordController.text.trim() != _confirmPasswordController.text.trim()) {
      setState(() {
        _statusMessage = "Passwords do not match!";
      });
      return;
    }

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      String? userId = userCredential.user?.uid;

      if (userId != null && _isShopAccount) {
        if (_shopNameController.text.isEmpty ||
            _shopDescriptionController.text.isEmpty ||
            _shopWebsiteController.text.isEmpty) {
          setState(() {
            _statusMessage = "Please fill all shop account details.";
          });
          return;
        }

        await _firestoreService.addShopUser(
          userId,
          _shopNameController.text.trim(),
          _shopDescriptionController.text.trim(),
          _shopWebsiteController.text.trim(),
        );

        await _firestoreService.createAdminRequest(
          userId,
          _shopNameController.text.trim(),
          _shopWebsiteController.text.trim(),
          _shopDescriptionController.text.trim(),
        );

        setState(() {
          _statusMessage = "Shop account created! Await admin approval.";
        });
      } else {
        setState(() {
          _statusMessage = "User registered successfully! Please verify your email.";
        });
      }

      await userCredential.user?.sendEmailVerification();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Verification email sent!")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LogInPage()),
      );
    } catch (e) {
      setState(() {
        _statusMessage = "Registration failed: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double appBarHeight = MediaQuery.of(context).size.height * 0.05;
    return Scaffold(
      backgroundColor: const Color(0xFF2E2E2E),
      appBar: AppBar(
        toolbarHeight:  appBarHeight,
        backgroundColor: const Color(0xFF5C8374),
        title: Padding(
          padding: EdgeInsets.only(bottom: appBarHeight * 0.1),
          child: const Text(
            'Register',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF000000),
            ),
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF93B1A6)),
      ),
      body: Container(
        color: const Color(0xFF2E2E2E),
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.8,
            ),
            child: ListView(
              children: [
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    labelStyle: TextStyle(color: Color(0xFF93B1A6)),
                    prefixIcon: Icon(Icons.email, color: Color(0xFF5C8374)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF5C8374)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF5C8374)),
                    ),
                  ),
                  style: const TextStyle(color: Color(0xFF93B1A6)),
                  cursorColor: const Color(0xFF5C8374),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: const TextStyle(color: Color(0xFF93B1A6)),
                    prefixIcon: const Icon(Icons.lock, color: Color(0xFF5C8374)),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
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
                  style: const TextStyle(color: Color(0xFF93B1A6)),
                  cursorColor: const Color(0xFF5C8374),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: !_isConfirmPasswordVisible,
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    labelStyle: const TextStyle(color: Color(0xFF93B1A6)),
                    prefixIcon: const Icon(Icons.lock, color: Color(0xFF5C8374)),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: const Color(0xFF5C8374),
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
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
                  style: const TextStyle(color: Color(0xFF93B1A6)),
                  cursorColor: const Color(0xFF5C8374),
                ),
                Row(
                  children: [
                    Checkbox(
                      activeColor: const Color(0xFF5C8374),
                      checkColor: const Color(0xFF93B1A6),
                      side: BorderSide(color: const Color(0xFF5C8374)),
                      value: _isShopAccount,
                      onChanged: (value) {
                        setState(() {
                          _isShopAccount = value ?? false;
                        });
                      },
                    ),
                    const Text(
                      "Register as Shop account",
                      style: TextStyle(color: Color(0xFF93B1A6)),
                    ),
                  ],
                ),
                if (_isShopAccount) ...[
                  _buildStyledTextField(
                    controller: _shopNameController,
                    labelText: "Shop Name",
                    isLink: false,
                  ),
                  _buildStyledTextField(
                    controller: _shopDescriptionController,
                    labelText: "Shop Description",
                    isLink: false,
                  ),
                  _buildStyledTextField(
                    controller: _shopWebsiteController,
                    labelText: "Shop Website",
                    isLink: true,
                  ),
                ],
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitRequest,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5C8374),
                  ),
                  child: Text(
                    _isShopAccount ? "Submit Request" : "Register",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  _statusMessage,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF93B1A6),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LogInPage()),
                    );
                  },
                  child: const Text(
                    "Already have an account? Log In",
                    style: TextStyle(color: Color(0xFF93B1A6)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStyledTextField({
    required TextEditingController controller,
    required String labelText,
    required bool isLink,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: Color(0xFF93B1A6)),
          prefixIcon: const Icon(Icons.store, color: Color(0xFF5C8374)),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF5C8374)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF5C8374)),
          ),
        ),
        style: const TextStyle(color: Color(0xFF93B1A6)),
        cursorColor: const Color(0xFF5C8374),
        inputFormatters: isLink ? [LinkInputFormatter()] : [],
      ),
    );
  }
}

