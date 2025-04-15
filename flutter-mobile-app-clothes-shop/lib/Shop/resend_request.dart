import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tresde/LoginSignup/log_in.dart';
import 'package:tresde/FirebaseFiles/firestore_service.dart';
import 'package:tresde/link_formatter.dart';

class ShopRequestForm extends StatefulWidget {

  const ShopRequestForm({super.key});

  @override
  State<ShopRequestForm> createState() => _ShopRequestFormState();
}

class _ShopRequestFormState extends State<ShopRequestForm> {
  final _formKey = GlobalKey<FormState>();
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _shopName = TextEditingController();
  final TextEditingController _shopDescription = TextEditingController();
  final TextEditingController _shopWebsite = TextEditingController();

  Future<void> _resendAdminRequest() async {
    if (_formKey.currentState!.validate()) {
      String? userId = await _firestoreService.getUserId();
      if (userId != null) {
        await _firestoreService.resendAdminRequest(
          userId,
          _shopName.text.trim(),
          _shopWebsite.text.trim(),
          _shopDescription.text.trim(),
        );

        _shopName.clear();
        _shopDescription.clear();
        _shopWebsite.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Request sent successfully.")),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _shopWebsite.text = "https://";
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "Unfortunately, your request has been denied. You can send a request again.",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text(
                    'Shop Name:',
                    style: TextStyle(
                      color: Color(0xFF5C8374),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  TextFormField(
                    controller: _shopName,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white12,
                      labelText: 'Enter shop name',
                      labelStyle: const TextStyle(color: Color(0xFF93B1A6)),
                      border: const OutlineInputBorder(),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF5C8374)),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF5C8374), width: 2.0),
                      ),
                    ),
                    style: const TextStyle(color: Color(0xFF93B1A6)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter shop name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),


                  const Text(
                    'Shop Description:',
                    style: TextStyle(
                      color: Color(0xFF5C8374),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  TextFormField(
                    controller: _shopDescription,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white12,
                      labelText: 'Enter shop description',
                      labelStyle: const TextStyle(color: Color(0xFF93B1A6)),
                      border: const OutlineInputBorder(),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF5C8374)),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF5C8374), width: 2.0),
                      ),
                    ),
                    style: const TextStyle(color: Color(0xFF93B1A6)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter shop description';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),


                  const Text(
                    'Shop Website:',
                    style: TextStyle(
                      color: Color(0xFF5C8374),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  TextFormField(
                    controller: _shopWebsite,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white12,
                      labelText: 'Enter shop website',
                      labelStyle: const TextStyle(color: Color(0xFF93B1A6)),
                      border: const OutlineInputBorder(),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF5C8374)),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF5C8374), width: 2.0),
                      ),
                    ),
                    style: const TextStyle(color: Color(0xFF93B1A6)),
                    inputFormatters: [
                      LinkInputFormatter()
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter shop website';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24.0),


                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Color(0xFF5C8374),
                      ),
                      onPressed: _resendAdminRequest,
                      child: const Text('Submit Request'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Successfully logged out.")),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LogInPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Logout failed: $e")),
      );
    }
  }
}
