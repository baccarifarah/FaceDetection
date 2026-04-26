import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FacePainter extends StatelessWidget {

  final List<Face> faces;
  final Size imageSize;

  const FacePainter({
    super.key,
    required this.faces,
    required this.imageSize,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _FaceCustomPainter(faces, imageSize),
    );
  }
}

class _FaceCustomPainter extends CustomPainter {

  final List<Face> faces;
  final Size imageSize;

  _FaceCustomPainter(this.faces, this.imageSize);

  @override
  void paint(Canvas canvas, Size size) {

    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final scaleX = size.width / imageSize.width;
    final scaleY = size.height / imageSize.height;

    for (Face face in faces) {

      final rect = face.boundingBox;

      final scaledRect = Rect.fromLTRB(
        rect.left * scaleX,
        rect.top * scaleY,
        rect.right * scaleX,
        rect.bottom * scaleY,
      );

      canvas.drawRect(scaledRect, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}