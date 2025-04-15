import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class ModelViewerScreen extends StatefulWidget {
  final String model;

  const ModelViewerScreen({super.key, required this.model});

  @override
  State<ModelViewerScreen> createState() => _ModelViewerScreenState();
}

class _ModelViewerScreenState extends State<ModelViewerScreen> {
  String? modelUrl;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      setState(() {
        modelUrl = widget.model;
        isLoading = false;
      });
    } catch (e) {
      print('Error al cargar el modelo: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double appBarHeight = MediaQuery.of(context).size.height * 0.05;
    return Scaffold(
      backgroundColor: Color(0xFF2E2E2E),
      appBar: AppBar(
        toolbarHeight:  appBarHeight,
        backgroundColor: const Color(0xFF5C8374),
        title: Padding(
          padding: EdgeInsets.only(bottom: appBarHeight * 0.1),
          child: const Text(
            '3D VIEW',
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Color.fromARGB(255, 255, 255, 255),))
          : modelUrl == null
          ? const Center(child: Text('Error al cargar el modelo.'))
          : Column(
        children: [
          Expanded(
            child: ModelViewer(
              src: modelUrl!,
              alt: "Modelo 3D desde Firebase Storage",
              autoRotate: true,
              cameraControls: true
            ),
          ),
        ],
      ),
    );
  }
}

