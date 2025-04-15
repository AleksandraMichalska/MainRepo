import 'package:flutter/material.dart';
import 'product_button.dart';
import 'package:tresde/FirebaseFiles/firestore_service.dart';

class SearchProductPage extends StatefulWidget {
  const SearchProductPage({super.key});

  @override
  State<SearchProductPage> createState() => _SearchProductPageState();
}

class _SearchProductPageState extends State<SearchProductPage> {
  final FirestoreService _firestoreService = FirestoreService();
  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    final products = await _firestoreService.getAllProducts();
    setState(() {
      _products = products..sort((a, b) => (b['likes'] ?? 0).compareTo(a['likes'] ?? 0));
      _filteredProducts = List.from(products);
    });
  }

  void _filterProducts(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredProducts = List.from(_products);
      } else {
        _filteredProducts = _products
            .where((product) =>
            product['prodName']!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final double appBarHeight = MediaQuery.of(context).size.height * 0.05;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight:  appBarHeight,
        backgroundColor: const Color(0xFF5C8374),
        title: Padding(
          padding: EdgeInsets.only(bottom: appBarHeight * 0.1),
          child: const Text(
            'Search Product',
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
        child: Column(
          children: [
            TextField(
              onChanged: _filterProducts,
              decoration: const InputDecoration(
                hintText:'Search...',
                hintStyle: TextStyle(color: Color.fromARGB(255, 163, 163, 163)),
                prefixIcon: Icon(Icons.search, color: Color(0xFF5C8374)),
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF5C8374)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF5C8374)),
                ),
              ),
              cursorColor: Colors.grey,
              style: const TextStyle(color: Color(0xFF5C8374)),
            ),

            const SizedBox(height: 16.0),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(

                  maxCrossAxisExtent: screenWidth * 0.45,
                  crossAxisSpacing: screenWidth * 0.02,
                  mainAxisSpacing: screenWidth * 0.02,
                ),
                itemCount: _filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = _filteredProducts[index];
                  return ProductButton(
                    name: product['prodName'] ?? '',
                    description: product['desc'] ?? '',
                    imagePath: product['imageURL'] ?? '',
                    category: product['category'] ?? '',
                    productId: product['id'] ?? '',
                    model: product['modelURL'] ?? '',
                    price: product['price'] ?? '',
                    link: product['linkWeb'] ?? '',
                    productHeightCm: product['productHeightCm']?.toDouble() ?? 0.0,
                    productWidthCm: product['productWidthCm']?.toDouble() ?? 0.0,
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






