import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import '../services/face_detector_service.dart';
import '../widgets/face_contour_painter.dart';

class FaceContourPage extends StatefulWidget {
  const FaceContourPage({super.key});

  @override
  State<FaceContourPage> createState() => _FaceContourPageState();
}

class _FaceContourPageState extends State<FaceContourPage> {

  File? _image;
  List<Face> _faces = [];
  Size? _imageSize;
  bool _loading = false;

  final ImagePicker _picker = ImagePicker();
  final FaceDetectorService _service = FaceDetectorService();

  Future<void> _pickImage(ImageSource source) async {

    final XFile? file = await _picker.pickImage(source: source);

    if (file == null) return;

    final imageFile = File(file.path);

    setState(() {
      _loading = true;
      _image = imageFile;
    });

    final bytes = await imageFile.readAsBytes();
    final uiImage = await decodeImageFromList(bytes);

    final faces = await _service.detectFaces(imageFile);

    setState(() {
      _faces = faces;
      _imageSize =
          Size(uiImage.width.toDouble(), uiImage.height.toDouble());
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Contours du visage"),
        backgroundColor: const ui.Color.fromARGB(255, 34, 137, 221),
      ),

      body: Column(
        children: [

          const SizedBox(height: 20),

          if (_image != null && _imageSize != null)
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [

                  Image.file(
                    _image!,
                    fit: BoxFit.contain,
                  ),

                  FaceContourPainter(
                    faces: _faces,
                    imageSize: _imageSize!,
                  ),
                ],
              ),
            ),

          if (_loading)
            const Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(),
            ),

          const SizedBox(height: 10),

          Text(
            "Visages détectés : ${_faces.length}",
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: ui.Color.fromARGB(255, 34, 137, 255)),
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const ui.Color.fromARGB(255, 175, 204, 250),
                ),
                onPressed: () => _pickImage(ImageSource.camera),
                icon: const Icon(Icons.camera_alt),
                label: const Text("Caméra"),
              ),

              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const ui.Color.fromARGB(255, 175, 204, 250),
                ),
                onPressed: () => _pickImage(ImageSource.gallery),
                icon: const Icon(Icons.photo),
                label: const Text("Galerie"),
              ),
            ],
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}