import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class EnhanceScreen extends StatefulWidget {
  const EnhanceScreen({super.key});

  @override
  _EnhanceScreenState createState() => _EnhanceScreenState();
}

class _EnhanceScreenState extends State<EnhanceScreen> {
  File? _image;
  final picker = ImagePicker();
  List<File> savedImages = [];

  @override
  void initState() {
    super.initState();
    _loadSavedImages();
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    setState(() {
      _image = File(pickedFile.path);
    });
  }

  Future<void> _enhanceImage() async {
    if (_image == null) return;

    try {
      Uint8List imageBytes = await _image!.readAsBytes();
      img.Image? image = img.decodeImage(Uint8List.fromList(imageBytes));

      if (image == null) {
        debugPrint("❌ Error: Unable to decode the image.");
        return;
      }

      image = img.adjustColor(image, brightness: 5, contrast: 0.175);

      final List<int> sharpenKernel = [
        0, -1,  0,
        -1,  5, -1,
        0, -1,  0
      ];
      image = img.convolution(image, filter: sharpenKernel, div: 1, offset: 0);

      final directory = await getApplicationDocumentsDirectory();
      final String newPath = '${directory.path}/enhanced_${DateTime.now().millisecondsSinceEpoch}.jpg';
      File enhancedFile = File(newPath);
      await enhancedFile.writeAsBytes(img.encodeJpg(image));

      setState(() {
        _image = enhancedFile;
        savedImages.add(enhancedFile);
      });

      debugPrint("✅ Image enhancement complete.");
    } catch (e) {
      debugPrint("❌ Error during enhancement: $e");
    }
  }

  Future<void> _loadSavedImages() async {
    final directory = await getApplicationDocumentsDirectory();
    final List<FileSystemEntity> files = directory.listSync();
    setState(() {
      savedImages = files.whereType<File>().toList();
    });
  }

  void _deleteImage(File image) {
    if (savedImages.contains(image)) {
      image.delete();
      setState(() {
        savedImages.remove(image);
      });
    }
  }

  void _openImage(File image) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImage(image: image, onDelete: () {
          _deleteImage(image);
          Navigator.pop(context);
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Enhance Image", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.photo_library),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SavedImagesScreen(savedImages: savedImages, onDelete: _deleteImage)),
            ),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image != null
                ? InteractiveViewer(
              child: Image.file(_image!, height: 300),
            )
                : const Icon(Icons.auto_fix_high, size: 100, color: Colors.blueAccent),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.file_upload),
              label: const Text("Upload Image"),
              onPressed: _pickImage,
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.auto_fix_normal),
              label: const Text("Enhance Image"),
              onPressed: _enhanceImage,
            ),
          ],
        ),
      ),
    );
  }
}

class SavedImagesScreen extends StatelessWidget {
  final List<File> savedImages;
  final Function(File) onDelete;

  const SavedImagesScreen({super.key, required this.savedImages, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Saved Images")),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 5, mainAxisSpacing: 5),
        itemCount: savedImages.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FullScreenImage(image: savedImages[index], onDelete: () {
                  onDelete(savedImages[index]);
                  Navigator.pop(context);
                }),
              ),
            ),
            child: Image.file(savedImages[index], fit: BoxFit.cover),
          );
        },
      ),
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final File image;
  final VoidCallback onDelete;

  const FullScreenImage({super.key, required this.image, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Image Viewer")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: Image.file(image)),
            ElevatedButton.icon(
              icon: const Icon(Icons.delete),
              label: const Text("Delete"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              onPressed: () {
                onDelete();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}