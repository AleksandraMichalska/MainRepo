import 'package:flutter/material.dart';
import 'package:tresde/Customer/scale_product.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model_view.dart';

class ProductInformationPage extends StatefulWidget {
  final String productName;
  final String description;
  final String link;
  final double price;
  final String imagePath;
  final String modelPath;
  final String category;
  final double productHeightCm;
  final double productWidthCm;

  const ProductInformationPage({
    super.key,
    required this.productName,
    required this.description,
    required this.link,
    required this.price,
    required this.imagePath,
    required this.modelPath,
    required this.category,
    required this.productHeightCm,
    required this.productWidthCm,
  });

  @override
  State<ProductInformationPage> createState() => _ProductInformationPageState();
}

class _ProductInformationPageState extends State<ProductInformationPage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final double appBarHeight = MediaQuery.of(context).size.height * 0.05;
    return Scaffold(
      backgroundColor: Color(0xFF2E2E2E),
      appBar: AppBar(
        toolbarHeight:  appBarHeight,
        backgroundColor: const Color(0xFF5C8374),
        title: Padding(
          padding: EdgeInsets.only(bottom: appBarHeight * 0.1),
          child: const Text(
            'Product information',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF000000),
            ),
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 255, 255, 255)),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
        child: Container(
          alignment: Alignment.topLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              Image.network(
                widget.imagePath,
                width: screenWidth,
                height: screenHeight * 0.4,
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
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: screenWidth * 0.7,
                    child: TextField(
                      controller: TextEditingController(text: widget.productName),
                      readOnly: true,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Color(0xFF5C8374),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    width: screenWidth * 0.3,
                    child: TextField(
                      controller: TextEditingController(text: '${widget.price} EUR'),
                      readOnly: true,
                      textAlign: TextAlign.right,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Color(0xFF5C8374),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: screenWidth * 0.4,
                    child: ColoredHyperlinkBox(link: widget.link),
                  ),
                  SizedBox(
                    width: screenWidth * 0.6,
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFF93B1A6),
                        borderRadius: BorderRadius.zero,
                        border: Border.all(color: Colors.transparent)
                      ),
                      child: Text(
                        'Size: ${widget.productHeightCm} x ${widget.productWidthCm} cm',
                        textAlign: TextAlign.right, 
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: screenHeight * 0.33,
                ),
                child: Text(
                  widget.description,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      Positioned(
            bottom: 16,
            left: 16,
            child: FloatingActionButton(
            heroTag: "ScaleButton",
            backgroundColor: const Color(0xFF5C8374),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ScaleScreen(
                    productHeightCm: widget.productHeightCm,
                    productWidthCm: widget.productWidthCm,
                    productModelURL: widget.modelPath,
                  ),
                ),
              );
            },
            child: const Icon(Icons.straighten, color: Colors.white),
          ),
      ),
      Positioned(
        bottom: 16,
        right: 16,
        child: FloatingActionButton(
            heroTag: '3DButton',
            backgroundColor: const Color(0xFF5C8374),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ModelViewerScreen(
                    model: widget.modelPath,
                  ),
                ),
              );
            },
            child: const Text('3D', style: TextStyle(color: Colors.white)),
          ),
      )
      ],
      )
    );
  }
}

class ColoredHyperlinkBox extends StatelessWidget {
  String link;
  ColoredHyperlinkBox({required this.link});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF93B1A6),
        borderRadius: BorderRadius.zero,
        border: Border.all(color: Colors.transparent)
      ),
      child: GestureDetector(
        onTap: () async {
          Uri url = Uri.parse(link);
          try {
            await launchUrl(url);
          } 
          catch(e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Could not launch link.")),
            );
          }
        },
        child: SizedBox(
              width: screenWidth,
              child: Text(
              'LINK',
              style: TextStyle(
              color: Colors.black,
              decoration: TextDecoration.underline,
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    );
  }
}
