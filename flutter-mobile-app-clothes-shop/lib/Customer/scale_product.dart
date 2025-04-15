import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class ScaleScreen extends StatelessWidget {
  final String productModelURL;
  final double productHeightCm;
  final double productWidthCm;

  const ScaleScreen({
    super.key,
    required this.productHeightCm,
    required this.productWidthCm,
    required this.productModelURL,
  });

  final double humanHeightCm = 21.2;
  final double humanWidthCm = 16.0;

  Future<String> _getHumanImageURL() async {
    return await FirebaseStorage.instance.ref('head-png.webp').getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E2E2E),
      appBar: AppBar(
        title: const Text(
          'Scale Product',
          style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF000000),
            ),),
        centerTitle: true,
        backgroundColor: const Color(0xFF5C8374),
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 255, 255, 255)),
      ),
      body: FutureBuilder(
        future: _getHumanImageURL(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading human image."));
          }

          String humanImageUrl = snapshot.data ?? '';

          return LayoutBuilder(
            builder: (context, constraints) {
              final double maxHeight = constraints.maxHeight * 0.5;
              final double availableWidth = constraints.maxWidth * 0.9;

              double scaleFactor = maxHeight / (humanHeightCm > productHeightCm ? humanHeightCm : productHeightCm);

              double humanWidthPx = humanWidthCm * scaleFactor;
              double productWidthPx = productWidthCm * scaleFactor;
              double totalWidthRequired = humanWidthPx + productWidthPx + 20;

              if (totalWidthRequired > availableWidth) {
                scaleFactor *= availableWidth / totalWidthRequired;
              }

              humanWidthPx = humanWidthCm * scaleFactor;
              productWidthPx = productWidthCm * scaleFactor;
              double humanHeightPx = humanHeightCm * scaleFactor;
              double productHeightPx = productHeightCm * scaleFactor;
              double maxImageHeight = humanHeightPx > productHeightPx ? humanHeightPx : productHeightPx;

              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Size references (height x width):',
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Head: ${humanHeightCm.toDouble()} x ${humanWidthCm.toDouble()} cm',
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Product: ${productHeightCm.toDouble()} x ${productWidthCm.toDouble()} cm',
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: maxImageHeight,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Image.network(
                              humanImageUrl,
                              width: humanWidthPx,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Container(
                          height: productHeightPx,
                          width: productWidthPx,
                          child: AspectRatio(
                            aspectRatio: productWidthCm / productHeightCm,
                            child: ModelViewer(
                              src: productModelURL,
                              autoRotate: false,
                              disableZoom: true,
                              cameraControls: true,
                              backgroundColor: Colors.transparent,
                              cameraOrbit: "0deg 90deg 2m",
                              fieldOfView: "30deg",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}