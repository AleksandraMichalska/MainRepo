import 'package:flutter/material.dart';
import 'previewpage.dart';

class ProductButton extends StatefulWidget {
  final String name;
  final String description;
  final String imagePath;
  final String modelPath;
  final String link;
  final String category;
  final double price;
  final String productID;
  final double heightcm;
  final double widthcm;

  const ProductButton({
    super.key,
    required this.name,
    required this.description,
    required this.imagePath,
    required this.link,
    required this.price,
    required this.modelPath,
    required this.category,
    required this.productID,
    required this.heightcm,
    required this.widthcm
  });

  @override
  State<ProductButton> createState() => _ProductButtonState();
}

class _ProductButtonState extends State<ProductButton> {
  bool isFavorite = false; 

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PreviewPage( name: widget.name,
              description: widget.description,
              imagePath: null,
              modelPath: null,
              networkImagePath: widget.imagePath,
              networkModelPath: widget.modelPath,
              link: widget.link,
              editDelete: true,
              price: widget.price,
              category: widget.category,
              uploadNew: false,
              productID: widget.productID,
              heightcm: widget.heightcm,
              widthcm: widget.widthcm,
              ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF5C8374),
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
          ],
        ),
      ),
    );
  }
}
