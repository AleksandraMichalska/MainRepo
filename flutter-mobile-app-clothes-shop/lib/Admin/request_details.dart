import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RequestDetailsPage extends StatelessWidget {
  final Map<String, dynamic> request;

  const RequestDetailsPage({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    final double appBarHeight = MediaQuery.of(context).size.height * 0.05;
    return Scaffold(
      backgroundColor: const Color(0xFF2E2E2E),
      appBar: AppBar(
        toolbarHeight:  appBarHeight,
        backgroundColor: const Color(0xFF5C8374),
        title: Padding(
          padding: EdgeInsets.only(bottom: appBarHeight * 0.1),
          child: const Text(
            'Request Details',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Shop Name:',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5C8374),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                request['shopName'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Description:',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5C8374),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                request['shopDescription'],
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Website:',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5C8374),
                ),
              ),
              const SizedBox(height: 4),
              ColoredHyperlinkBox(link: request['shopWebsite']),
            ],


          ),
        ),
      ),
    );
  }
}

class ColoredHyperlinkBox extends StatelessWidget {
  final String link;
  ColoredHyperlinkBox({required this.link});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF93B1A6),
        borderRadius: BorderRadius.zero,
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
              link,
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
