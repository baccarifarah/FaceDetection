import 'dart:io';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceDetectorService {

  final FaceDetector _detector = FaceDetector(
    options: FaceDetectorOptions(
      performanceMode: FaceDetectorMode.accurate,
      enableContours: true,
    ),
  );

  Future<List<Face>> detectFaces(File file) async {

    final inputImage = InputImage.fromFile(file);

    final faces = await _detector.processImage(inputImage);

    return faces;
  }

  void dispose() {
    _detector.close();
  }
}



