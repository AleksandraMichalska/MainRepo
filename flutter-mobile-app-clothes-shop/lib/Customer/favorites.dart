import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tresde/FirebaseFiles/firestore_service.dart';
import 'product_button.dart';

class WardrobePage extends StatefulWidget {
  const WardrobePage({super.key});

  @override
  State<WardrobePage> createState() => _WardrobePageState();
}

class _WardrobePageState extends State<WardrobePage> {
  final FirestoreService _firestoreService = FirestoreService();
  Stream<List<DocumentSnapshot>>? _favoritesStream;
  String selectedCategory = 'All Favorites';

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      await _initializeFavoritesStream();
    });
  }

  Future<void> _initializeFavoritesStream() async {
    final userId = await _firestoreService.getUserId();
    if (userId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please sign in to view favorites.'))
        );
      }
      return;
    }
    if (mounted) {
      setState(() {
        _favoritesStream = _firestoreService.getUserFavorites(userId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final double appBarHeight = MediaQuery.of(context).size.height * 0.05;
    return Scaffold(
      backgroundColor: Color(0xFF2E2E2E),
      appBar: AppBar(
          toolbarHeight:  appBarHeight,
        backgroundColor: const Color(0xFF5C8374),
        title: Padding(
          padding: EdgeInsets.only(bottom: appBarHeight * 0.1),
          child: const Text(
            'Favorites',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF000000),
            ),
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 253, 253, 253)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Dropdown Selector for Category
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF2E2E2E),
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
                items: ['All Favorites', 'Headwear', 'Earrings', 'Necklaces', 'FaceAccessory']
                    .map<DropdownMenuItem<String>>((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        category,
                        style: const TextStyle(

                          color: Color(0xFF5C8374),
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  );
                }).toList(),
                underline: Container(),
                borderRadius: BorderRadius.circular(8.0),
                style: const TextStyle(color: Color(0xFF2C2C2C)),
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: StreamBuilder<List<DocumentSnapshot>>(
                stream: _favoritesStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF2E2E2E),
                      ),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        'No favorites yet!',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF93B1A6),
                        ),
                      ),
                    );
                  }
                  final items = selectedCategory == 'All Favorites' 
                    ? snapshot.data!
                    : snapshot.data!
                      .where((doc) => doc['category'] == selectedCategory)
                      .toList();

                  if (items.isEmpty) {
                    return const Center(
                      child: Text(
                        'No favorites in this category yet!',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF93B1A6),
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
                            category: item['category'],
                            model: item['modelURL'],
                            price: item['price'],
                            link: item['linkWeb'],
                            productId: items[index].id,
                            productHeightCm: item['productHeightCm'].toDouble(),
                            productWidthCm: item['productWidthCm'].toDouble(),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}