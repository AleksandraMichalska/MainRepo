import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tresde/LoginSignup/log_in.dart';
import 'package:tresde/FirebaseFiles/firestore_service.dart';
import 'product_button_shop.dart';
import "edit_form.dart";
import 'package:cloud_firestore/cloud_firestore.dart';

class UploadsPage extends StatefulWidget {
  const UploadsPage({super.key});

  @override
  State<UploadsPage> createState() => _UploadsPageState();
}

class _UploadsPageState extends State<UploadsPage> {
  Stream<List<DocumentSnapshot>>? _itemsStream;
  String selectedCategory = 'All Uploads';
  final FirestoreService _firestoreService = FirestoreService();
  List<String> categories = ['All Uploads','Headwear', 'Earrings', 'Necklaces', 'FaceAccessory'];

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

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      await _initializeItemsStream();
    });
  }

  Future<void> _initializeItemsStream() async {
    final userId = await _firestoreService.getUserId();
    if (userId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please sign in to view Uploads.'))
        );
      }
      return;
    }
    if (mounted) {
      setState(() {
        _itemsStream = _firestoreService.getUploadedProducts(userId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final double appBarHeight = MediaQuery.of(context).size.height * 0.05;
    return Scaffold(
      backgroundColor: const Color(0xFF2E2E2E),
      appBar: AppBar(
        toolbarHeight:  appBarHeight,
        backgroundColor: const Color(0xFF5C8374),
        title: Padding(
          padding: EdgeInsets.only(bottom: appBarHeight * 0.1),
          child: const Text(
            'Uploaded Products',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF5C8374), width: 2.0),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: DropdownButton<String>(
                value: selectedCategory,
                isExpanded: true,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCategory = newValue!;
                  });
                },
                items: categories
                    .map<DropdownMenuItem<String>>((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        category,
                        style: const TextStyle(
                            color: Color(0xFF5C8374), fontSize: 16.0),
                      ),
                    ),
                  );
                }).toList(),
                underline: Container(),
                borderRadius: BorderRadius.circular(8.0),
                style: const TextStyle(color: Color(0xFF5C8374)),
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: StreamBuilder<List<DocumentSnapshot>>(
                stream: _itemsStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        'No uploads yet!',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5C8374),
                        ),
                      ),
                    );
                  }
                  final items = selectedCategory == 'All Uploads'
                      ? snapshot.data!
                      : snapshot.data!
                      .where((doc) => doc['category'] == selectedCategory)
                      .toList();

                  if (items.isEmpty) {
                    return const Center(
                      child: Text(
                        'No uploads in this category yet!',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5C8374),
                        ),
                      ),
                    );
                  }

                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(

                      maxCrossAxisExtent: screenWidth * 0.45,
                      crossAxisSpacing: screenWidth * 0.02,
                      mainAxisSpacing: screenWidth * 0.02,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index].data() as Map<String, dynamic>;
                      return LayoutBuilder(
                        builder: (context, constraints) {
                        return ProductButton(
                          name: item['prodName'],
                          description: item['desc'],
                          imagePath: item['imageURL'],
                          link: item['linkWeb'],
                          price: item['price'],
                          modelPath: item['modelURL'],
                          category: item['category'],
                          productID: items[index].id,
                          widthcm: item['productWidthCm'],
                          heightcm: item['productHeightCm']
                        );
                      });
                    },
                  );
              })
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF5C8374),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FormPage(name: null,networkImagePath: null, networkModelPath: null, description: null, price: null, link: null, category: null, emptyForm: true, productID: null, widthcm: null, heightcm: null)),
          );
        },
        child: const Icon(Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
