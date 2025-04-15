import 'package:flutter/material.dart';
import 'package:tresde/FirebaseFiles/firestore_service.dart';
import 'infopage.dart';

class ProductButton extends StatefulWidget {
  final String name;
  final String description;
  final String imagePath;
  final String productId;
  final String category;
  final String model;
  final double price;
  final String link;
  final double productHeightCm;
  final double productWidthCm;

  const ProductButton({
    super.key,
    required this.name,
    required this.description,
    required this.imagePath,
    required this.productId,
    required this.category,
    required this.model,
    required this.price,
    required this.link,
    required this.productHeightCm,
    required this.productWidthCm,
  });

  @override
  State<ProductButton> createState() => _ProductButtonState();
}

class _ProductButtonState extends State<ProductButton> {
  bool isFavorite = false;
  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  Future<void> _checkFavoriteStatus() async {
    final userId = await _firestoreService.getUserId();
    if (userId == null) return;
    bool favoriteStatus = await _firestoreService.isFavorite(userId, widget.productId, widget.category);
    setState(() {
      isFavorite = favoriteStatus;
    });
  }

  void toggleFavorite() async {
    final userId = await _firestoreService.getUserId();
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please sign in to add favorites.'))
      );
      return;
    }
    setState(() {
      isFavorite = !isFavorite;
    });

    if (isFavorite) {
      await _firestoreService.addFavorite(userId, widget.productId, widget.category);
    } else {
      await _firestoreService.removeFavorite(userId, widget.productId, widget.category);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductInformationPage(
              productName: widget.name,
              imagePath: widget.imagePath,
              description: widget.description,
              modelPath: widget.model,
              price: widget.price,
              link: widget.link,
              category: widget.category,
              productHeightCm: widget.productHeightCm,
              productWidthCm: widget.productWidthCm,
            ),
          ),
        );
      },
      child: Container(

        decoration: BoxDecoration(
          color: const Color(0xFF93B1A6),
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0),
                  ),
                  child: widget.imagePath.isNotEmpty
                      ? Image.network(
                    widget.imagePath,
                    height: 120,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error, size: 120, color: Colors.red);
                    },
                  )
                      : const Icon(Icons.image_not_supported, size: 120, color: Colors.grey),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Positioned(
              top: 8.0,
              right: 8.0,
              child: GestureDetector(
                onTap: toggleFavorite,
                child: Icon(
                  Icons.favorite,
                  size: 28.0,
                  color: isFavorite ? Colors.red : Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
