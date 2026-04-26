import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/face_detector_service.dart';
import '../widgets/face_painter.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceCounterPage extends StatefulWidget {
  const FaceCounterPage({super.key});

  @override
  State<FaceCounterPage> createState() => _FaceCounterPageState();
}

class _FaceCounterPageState extends State<FaceCounterPage> {
  File? _image;
  List<Face> _faces = [];
  ui.Image? _uiImage;
  Size? _imageSize;
  bool _isLoading = false;

  final ImagePicker _picker = ImagePicker();
  final FaceDetectorService _faceService = FaceDetectorService();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile =
        await _picker.pickImage(source: source);

    if (pickedFile != null) {
      final file = File(pickedFile.path);

      setState(() {
        _image = file;
        _isLoading = true;
        _faces = [];
      });

      await _loadImage(file);
      final faces = await _faceService.detectFaces(file);

      setState(() {
        _faces = faces;
        _isLoading = false;
      });
    }
  }

  Future<void> _loadImage(File file) async {
    final data = await file.readAsBytes();
    final image = await decodeImageFromList(data);

    setState(() {
      _uiImage = image;
      _imageSize =
          Size(image.width.toDouble(), image.height.toDouble());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Compteur de visages"),
        backgroundColor: const ui.Color.fromARGB(255, 34, 137, 221),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            if (_uiImage != null && _imageSize != null)
              AspectRatio(
                aspectRatio:
                    _imageSize!.width / _imageSize!.height,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.file(_image!, fit: BoxFit.contain),
                    FacePainter(
                      faces: _faces,
                      imageSize: _imageSize!,
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 20),

            if (_isLoading)
              const CircularProgressIndicator(),

            const SizedBox(height: 20),

            Text(
              "Nombre de visages : ${_faces.length}",
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: ui.Color.fromARGB(255, 34, 137, 255)),
            ),

            const SizedBox(height: 40),

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const ui.Color.fromARGB(255, 175, 204, 250),
                  ),
                  onPressed: () =>
                      _pickImage(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text("Caméra"),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const ui.Color.fromARGB(255, 175, 204, 250),
                  ),
                  onPressed: () =>
                      _pickImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo),
                  label: const Text("Galerie"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}