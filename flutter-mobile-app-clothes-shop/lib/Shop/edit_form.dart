import 'package:flutter/material.dart';
import 'package:tresde/Shop/previewpage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:tresde/link_formatter.dart';

class FormPage extends StatefulWidget {
  String? name;
  String? description;
  String? link;
  double? price;
  String? networkImagePath;
  String? networkModelPath;
  String? category;
  String? productID;
  double? widthcm;
  double? heightcm;
  bool emptyForm;


  FormPage({super.key, required this.heightcm, required this.widthcm, required this.productID, required this.name, required this.description, required this.link, required this.price, required this.networkImagePath, required this.networkModelPath, required this.category, required this.emptyForm});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _linkController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _widthController = TextEditingController();
  final _heightController = TextEditingController();

  String? _category;
  String? _ImageFile;
  String? _ModelFile;

  void _pick3DModel() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.any,
  );

  if (result != null) {
    String filePath = result.files.single.path!;
    String? fileExtension = result.files.single.extension;

    if (['obj', 'fbx', 'stl', 'glb'].contains(fileExtension?.toLowerCase())) {
      setState(() {
        _ModelFile = filePath;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please choose a 3D model file.')),
      );
    }
  } 
  }

  void _pickImageFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['jpg', 'jpeg', 'png', 'gif'],
    );
    if (result != null) {
    String? fileExtension = result.files.single.extension;
    String filePath = result.files.single.path!;

    if (['jpg', 'jpeg', 'png', 'gif'].contains(fileExtension?.toLowerCase())) {
      setState(() {
        _ImageFile = filePath;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please choose an image file.')),
      );
    }
  }
  }

  @override
  void initState() {
    super.initState();
    if(!widget.emptyForm){
      _nameController.text = widget.name!;
      _linkController.text = widget.link!;
      _descriptionController.text = widget.description!;
      _priceController.text = widget.price!.toString();
      _widthController.text = widget.widthcm!.toString();
      _heightController.text = widget.heightcm!.toString();
      _category = widget.category;
    }
    else 
    {
      _linkController.text = "https://";
    }
  }


  @override
  Widget build(BuildContext context) {
    final double appBarHeight = MediaQuery.of(context).size.height * 0.05;
    return Scaffold(
      backgroundColor: const Color(0xFF2E2E2E),
      appBar: AppBar(
        toolbarHeight:  appBarHeight,
        backgroundColor: const Color(0xFF5C8374), // Gris oscuro
        title: Padding(
          padding: EdgeInsets.only(bottom: appBarHeight * 0.1), // Ajusta según lo que necesites
          child: const Text(
            'Edit Product',
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
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Product's name",
                  labelStyle: TextStyle(color: Color(0xFF5C8374)),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF5C8374)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF5C8374)),
                  ),
                  filled: true,
                  fillColor: Color(0xFF2E2E2E),
                ),
                style: TextStyle(color: Color(0xFF5C8374)),
                cursorColor: Color(0xFF5C8374),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _linkController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  labelText: "Link to the website",
                  labelStyle: TextStyle(color: Color(0xFF5C8374)),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF5C8374)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF5C8374)),
                  ),
                  filled: true,
                  fillColor: Color(0xFF2E2E2E),
                ),
                style: TextStyle(color: Color(0xFF5C8374)),
                cursorColor: Color(0xFF5C8374),
                inputFormatters: [
                  LinkInputFormatter()
                ],
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: "Description",
                  labelStyle: TextStyle(color: Color(0xFF5C8374)),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF5C8374)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF5C8374)),
                  ),
                  filled: true,
                  fillColor: Color(0xFF2E2E2E),
                ),
                style: TextStyle(color: Color(0xFF5C8374)),
                cursorColor: Color(0xFF5C8374),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: "Price in EUR",
                  labelStyle: TextStyle(color: Color(0xFF5C8374)),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF5C8374)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF5C8374)),
                  ),
                  filled: true,
                  fillColor: Color(0xFF2E2E2E),
                ),
                style: TextStyle(color: Color(0xFF5C8374)),
                cursorColor: Color(0xFF5C8374),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[\d\.]')),
                  CurrencyInputFormatter(),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _widthController,
                decoration: InputDecoration(
                  labelText: "Width in cm",
                  labelStyle: TextStyle(color: Color(0xFF5C8374)),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF5C8374)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF5C8374)),
                  ),
                  filled: true,
                  fillColor: Color(0xFF2E2E2E),
                ),
                style: TextStyle(color: Color(0xFF5C8374)),
                cursorColor: Color(0xFF5C8374),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[\d\.]')),
                  CurrencyInputFormatter(),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _heightController,
                decoration: InputDecoration(
                  labelText: "Height in cm",
                  labelStyle: TextStyle(color: Color(0xFF5C8374)),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF5C8374)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF5C8374)),
                  ),
                  filled: true,
                  fillColor: Color(0xFF2E2E2E),
                ),
                style: TextStyle(color: Color(0xFF5C8374)),
                cursorColor: Color(0xFF5C8374),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[\d\.]')),
                  CurrencyInputFormatter(),
                ],
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: widget.emptyForm ? "Category" : "Category can't be edited",
                  labelStyle: TextStyle(color: Color(0xFF5C8374)),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF5C8374)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF5C8374)),
                  ),
                  filled: true,
                  fillColor: Color(0xFF2E2E2E),
                ),
                value: _category,
                items: ['Headwear', 'Necklaces', 'Earrings', 'FaceAccessory']
                    .map((option) => DropdownMenuItem(
                  value: option,
                  child: Text(option, style: TextStyle(color: Color(0xFF5C8374))),
                ))
                    .toList(),
                onChanged: widget.emptyForm ?
                    (value) {
                  setState(() {
                    _category = value;
                  });
                } : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _pickImageFile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5C8374),
                      foregroundColor: const Color(0xFF000000),
                    ),
                    child: Text("Choose product's image"),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _ImageFile ?? 'Image not chosen',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Color(0xFF5C8374)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _pick3DModel,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5C8374),
                      foregroundColor: const Color(0xFF000000),
                    ),
                    child: Text("Choose 3D model"),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _ModelFile ?? 'Model not chosen',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Color(0xFF5C8374)),
                    ),
                  ),
                ],
              ),
            ],),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF5C8374),
        onPressed: () async {
          try {
            if (_nameController.text == "") {
                throw Exception('Name is required.');
            }
            if (_descriptionController.text == "") {
                throw Exception('Description is required.');
            }
            if (_priceController.text == "") {
                throw Exception('Price is required.');
            }
            if (_widthController.text == "") {
                throw Exception('Width is required.');
            }
            if (_heightController.text == "") {
                throw Exception('Height is required.');
            }
            if (_category == null) {
                throw Exception('Category is required.');
            }
            if(widget.emptyForm) {
              if (_ImageFile == null) {
                throw Exception('Please choose an image file.');
              }
              if (_ModelFile == null) {
                throw Exception('Please choose a 3D model file.');
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PreviewPage(name: _nameController.text,
                    description: _descriptionController.text,
                    imagePath: _ImageFile!,
                    modelPath: _ModelFile!,
                    networkImagePath: null,
                    networkModelPath: null,
                    link: _linkController.text,
                    price: double.parse(_priceController.text),
                    editDelete: false,
                    category: _category!,
                    uploadNew: true,
                    productID: null,
                    heightcm: double.parse(_heightController.text),
                    widthcm: double.parse(_widthController.text),
                  ),
                ),
              );
            }
            else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PreviewPage(name: _nameController.text,
                    description: _descriptionController.text,
                    imagePath: _ImageFile,
                    modelPath: _ModelFile,
                    networkImagePath: widget.networkImagePath,
                    networkModelPath: widget.networkModelPath,
                    link: _linkController.text,
                    price: double.parse(_priceController.text),
                    editDelete: false,
                    category: _category!,
                    uploadNew: false,
                    productID: widget.productID,
                    heightcm: double.parse(_heightController.text),
                    widthcm: double.parse(_widthController.text),
                  ),
                ),
              );
            }
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('$e')),
            );
          }
        },
        child: const Icon(Icons.remove_red_eye,
          color: Colors.white,
        ),
      ),
    );
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = newValue.text;
    final regex = RegExp(r'^(\d+(\.\d{0,2})?)?$');
    if (regex.hasMatch(newText)) {
      return newValue;
    }
    return oldValue;
  }
}