import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tresde/LoginSignup/log_in.dart';
import 'package:tresde/Shop/resend_request.dart';
import 'package:tresde/FirebaseFiles/firestore_service.dart';

class RequestStatusPage extends StatefulWidget {
  const RequestStatusPage({super.key});

  @override
  State<RequestStatusPage> createState() => _RequestStatusPageState();
}

class _RequestStatusPageState extends State<RequestStatusPage> {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: const Color(0xFF2E2E2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF5C8374),
        title: const Text("Request Status"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _logout();
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Center(
        child: user != null
            ? FutureBuilder<String>(
                future: _firestoreService.checkRequestStatus(user.uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red, fontSize: 18),
                      textAlign: TextAlign.center,
                    );
                  } else if (snapshot.hasData) {
                    return _buildStatusContent(snapshot.data!);
                  } else {
                    return const Text(
                      "Unknown error occurred.",
                      style: TextStyle(color: Colors.red, fontSize: 18),
                      textAlign: TextAlign.center,
                    );
                  }
                },
              )
            : const Text(
                "User not authenticated. Please log in.",
                style: TextStyle(color: Colors.red, fontSize: 18),
                textAlign: TextAlign.center,
              ),
      ),
    );
  }

  Widget _buildStatusContent(String status) {
    if (status == "Denied") {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: ShopRequestForm(),
      );
    } else {
      return Text(
        status == "Pending"
            ? "Your request is still pending."
            : "No request found. Please submit your details.",
        style: TextStyle(
          color: status == "Pending" ? Color(0xFF93B1A6) : Colors.grey,
          fontSize: 18,
        ),
        textAlign: TextAlign.center,
      );
    }
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

  void _reloadStatus() {
    setState(() {});
  }
}
