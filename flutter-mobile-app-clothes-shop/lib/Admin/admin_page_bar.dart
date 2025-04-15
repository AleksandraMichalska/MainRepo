import 'package:flutter/material.dart';
import 'package:tresde/Admin/admin_page.dart';
import 'package:tresde/Admin/admin_settings.dart';


class MainPageAdmin extends StatefulWidget {
  const MainPageAdmin({super.key});

  @override
  State<MainPageAdmin> createState() => _MyAppState();
}

class _MyAppState extends State<MainPageAdmin> {
  var selectedIndex = 0;

  final List<Widget> _pages = [
    AdminPage(),
    SettingsAdminPage(),
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
              icon: Icon(Icons.maps_ugc),
              label: 'Requests',
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