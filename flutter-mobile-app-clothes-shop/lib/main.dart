import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tresde/Admin/admin_page_bar.dart';
import 'package:tresde/Shop/main_page_shop.dart';
import 'package:tresde/Shop/not_accepted.dart';
import 'package:tresde/FirebaseFiles/firestore_service.dart';
import 'FirebaseFiles/firebase_setup.dart';
import 'LoginSignup/log_in.dart';
import 'main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseSetup.initializeFirebase();
  FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: true);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthCheck(),
    );
  }
}

class AuthCheck extends StatelessWidget {
  AuthCheck({super.key});
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: FirebaseAuth.instance.authStateChanges().first,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          final user = snapshot.data;
          if (user != null) {
            return FutureBuilder<bool>(
              future: _firestoreService.isAdmin(user.uid),
              builder: (context, adminSnapshot) {
                if (adminSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (adminSnapshot.hasData && adminSnapshot.data == true) {
                  return const MainPageAdmin();
                } else {
                  return FutureBuilder<bool>(
                    future: _firestoreService.isShopUser(user.uid),
                    builder: (context, shopSnapshot) {
                      if (shopSnapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (shopSnapshot.hasData && shopSnapshot.data == true) {

                        return FutureBuilder<bool>(
                          future: _firestoreService.isUserAccepted(user.uid),
                          builder: (context, acceptedSnapshot) {
                            if (acceptedSnapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (acceptedSnapshot.hasData) {
                              if (acceptedSnapshot.data == true) {
                                return const MainPageShop();
                              } else {

                                return RequestStatusPage();
                              }
                            } else {

                              return const Center(child: Text("Error checking acceptance status."));
                            }
                          },
                        );
                      } else {

                        return const MainPage();
                      }
                    },
                  );
                }
              },
            );
          }
          return const MainPage();
        } else {
          return const LogInPage();
        }
      },
    );
  }
}
