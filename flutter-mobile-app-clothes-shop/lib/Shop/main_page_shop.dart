import 'package:flutter/material.dart';
import 'package:tresde/LoginSignup/settings_page.dart';
import 'package:tresde/Shop/uploaded_models.dart';


class MainPageShop extends StatefulWidget {
  const MainPageShop({super.key});

  @override
  State<MainPageShop> createState() => _MyAppState();
}

class _MyAppState extends State<MainPageShop> {
  var selectedIndex = 0;

  final List<Widget> _pages = [
    UploadsPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xFF2E2E2E),

        body: _pages[selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Color(0xFF2E2E2E),
          selectedItemColor: Color(0xFF5C8374),
          unselectedItemColor: Colors.grey,
          currentIndex: selectedIndex,
          onTap: (int index) {
            setState(() {
              selectedIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.drive_folder_upload),
              label: 'Uploads',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}