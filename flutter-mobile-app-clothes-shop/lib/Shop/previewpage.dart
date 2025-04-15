import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'edit_form.dart';
import 'package:tresde/FirebaseFiles/firestore_service.dart';
import 'package:confirm_dialog/confirm_dialog.dart';

class PreviewPage extends StatelessWidget {
  final String name;
  final String description;
  final String link;
  final double price;
  final String? imagePath;
  final String? modelPath;
  final String? networkImagePath;
  final String? networkModelPath;
  final String category;
  final bool editDelete;
  final bool uploadNew;
  final String? productID;
  final double heightcm;
  final double widthcm;

  PreviewPage({super.key, required this.heightcm, required this.widthcm, required this.productID, required this.name, required this.description, required this.link, required this.price, required this.imagePath, required this.modelPath,  required this.networkImagePath, required this.networkModelPath, required this.category, required this.uploadNew, required this.editDelete});

  Icon leftIcon = Icon(Icons.cancel, color: Colors.white);
  Icon rightIcon = Icon(Icons.check_circle, color: Colors.white);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    if(editDelete) {
      leftIcon = Icon(Icons.delete, color: Colors.white);
      rightIcon = Icon(Icons.edit, color: Colors.white);
    }

    Image createImage() {
      Image img;
      if(!editDelete) {
        if(imagePath != null) {
          img = Image.file(File(imagePath!),
          width: screenWidth,
            height: screenHeight*0.4,
            fit: BoxFit.cover,
          );
        }
        else
        {
          img = Image.network(networkImagePath!,
          width: screenWidth,
          height: screenHeight*0.4,
          fit: BoxFit.cover,
          );
        }
      }  
      else { 
          img = Image.network(networkImagePath!,
          width: screenWidth,
          height: screenHeight*0.4,
          fit: BoxFit.cover,
          );
        }
      return img;    
      }

    return Scaffold(
      backgroundColor: const Color(0xFF2E2E2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF5C8374),
        title:
         const Text('Product information', 
          style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF000000),
          ),
        ),
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 255, 255, 255)),
        centerTitle: true,
      ),
      body:Stack(
        children: [
          SingleChildScrollView(
        child: Container(
          alignment: Alignment.topLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              createImage(),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: screenWidth*0.7,
                    child: TextField(
                      controller: TextEditingController(text: name),
                      readOnly: true,
                      decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFF93B1A6),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.zero,
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    width: screenWidth*0.3,
                    child: TextField(
                      controller: TextEditingController(text: "$price EUR"),
                      readOnly: true,
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFF93B1A6),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.zero,
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: TextStyle(color: Colors.black),
                    ),
                  ),
                ]
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: screenWidth * 0.4,
                    child: ColoredHyperlinkBox(link: link),
                  ),
                  SizedBox(
                    width: screenWidth * 0.6,
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFF5C8374),
                        borderRadius: BorderRadius.zero,
                        border: Border.all(color: Colors.transparent)
                      ),
                      child: Text(
                        'Size: $heightcm x $widthcm cm',
                        textAlign: TextAlign.right, 
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                ]
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: screenHeight*0.33,
                ),
                child: Padding( 
                  padding: EdgeInsets.all(16.0),
                    child: Text(
                    description,
                    style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    ),  
                  ),
                )  
              )        
            ],
          ),
        ),
      ),
      Positioned(
              bottom: 16,
              left: 16,
              child: FloatingActionButton(
                heroTag: "leftbtn",
                backgroundColor: Color(0xFF5C8374),
                onPressed: () async {
                  if(editDelete) {
                    if (await confirm(
                      context,
                      title: const Text('Confirm deletion'),
                      content: const Text('Would you like to delete this product?'),
                      textOK: const Text('Yes'),
                      textCancel: const Text('No'),
                      )) {
                      final FirestoreService firestoreService = FirestoreService();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Deleting product...")),
                      );
                      final userId = await firestoreService.getUserId();

                      await firestoreService.removeProduct(productID!, category, userId!);
                      Navigator.pop(context);
                    }
                  }
                  else {
                    if(!uploadNew)
                    {
                      Navigator.pop(context);
                    }
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }
                },
                child: leftIcon
              ),
            ),
      Positioned(
              bottom: 16,
              right: 16,
              child: FloatingActionButton(
                heroTag: "rightbtn",
                backgroundColor: Color(0xFF5C8374),
                onPressed: () async {
                  if(editDelete) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FormPage(name: name,
                          description: description,
                          networkImagePath: networkImagePath,
                          networkModelPath: networkModelPath,
                          link: link,
                          price: price,
                          emptyForm: false,
                          category: category,
                          productID: productID,
                          heightcm: heightcm,
                          widthcm: widthcm
                          ),
                      ),
                    );
                  }
                  else {
                    if(uploadNew) {
                      final FirestoreService firestoreService = FirestoreService();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Sending data...")),
                      );
                        String? imageURL;
                        String? modelURL;
                        final file1 = File(imagePath!);
                        imageURL = await firestoreService.uploadImage(file1, name);
                        final file = File(modelPath!);
                        modelURL = await firestoreService.uploadModel(file, name);

                      final userId = await firestoreService.getUserId();

                      firestoreService.addProduct(
                      name,
                      link,
                      description,
                      price.toDouble(),
                      category,
                      imageURL,
                      modelURL,
                      userId!,
                      heightcm,
                      widthcm,
                      );
                    } 
                  else {
                    final FirestoreService firestoreService = FirestoreService();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Sending data...")),
                      );
                        String? imageURL;
                        String? modelURL;

                        if(imagePath != null) {
                          final file1 = File(imagePath!);
                          imageURL = await firestoreService.uploadImage(file1, name);
                        }
                        else
                        {
                          imageURL = networkImagePath;
                        }

                        if(modelPath != null) {
                          final file = File(modelPath!);
                          modelURL = await firestoreService.uploadModel(file, name);
                        }
                        else
                        {
                          modelURL = networkModelPath;
                        }
                      String? userId = await firestoreService.getUserId();
                      firestoreService.updateProduct(
                      productID!,
                      category,
                      name,
                      link,
                      description,
                      price,
                      modelURL!, 
                      imageURL!,
                      userId!,
                      heightcm,
                      widthcm,
                      );
                    Navigator.pop(context);
                  }
                  Navigator.pop(context);
                  Navigator.pop(context);   
                  }
                },
                child: rightIcon
              ),
            ),
      ],
    ) 
    );
  }
}
class ColoredHyperlinkBox extends StatelessWidget {
  String link;
  ColoredHyperlinkBox({super.key, required this.link});

  void _launchURL() async {
    
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF5C8374),
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
