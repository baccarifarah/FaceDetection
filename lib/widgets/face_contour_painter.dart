import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceContourPainter extends StatelessWidget {

  final List<Face> faces;
  final Size imageSize;

  const FaceContourPainter({
    super.key,
    required this.faces,
    required this.imageSize,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ContourPainter(faces, imageSize),
    );
  }
}

class _ContourPainter extends CustomPainter {

  final List<Face> faces;
  final Size imageSize;

  _ContourPainter(this.faces, this.imageSize);

  final Map<FaceContourType, Color> contourColors = {

    FaceContourType.face: Colors.blue,

    FaceContourType.leftEyebrowTop: Colors.red,
    FaceContourType.leftEyebrowBottom: Colors.orange,

    FaceContourType.rightEyebrowTop: Colors.green,
    FaceContourType.rightEyebrowBottom: Colors.purple,

    FaceContourType.leftEye: Colors.orange,
    FaceContourType.rightEye: Colors.cyan,

    FaceContourType.upperLipTop: Colors.pink,
    FaceContourType.upperLipBottom: Colors.green,

    FaceContourType.lowerLipTop: Colors.red,
    FaceContourType.lowerLipBottom: Colors.blue,

    FaceContourType.noseBridge: Colors.purple,
    FaceContourType.noseBottom: Colors.teal,
  };

  @override
  void paint(Canvas canvas, Size size) {

    final scaleX = size.width / imageSize.width;
    final scaleY = size.height / imageSize.height;

    for (Face face in faces) {

      contourColors.forEach((type, color) {

        final contour = face.contours[type];

        if (contour == null) return;

        final points = contour.points;

        if (points.isEmpty) return;

        final paint = Paint()
          ..color = color
          ..strokeWidth = 3
          ..style = PaintingStyle.stroke;

        final pointPaint = Paint()
          ..color = color
          ..style = PaintingStyle.fill;

        final path = Path();

        for (int i = 0; i < points.length; i++) {

          final x = points[i].x * scaleX;
          final y = points[i].y * scaleY;

          if (i == 0) {
            path.moveTo(x, y);
          } else {
            path.lineTo(x, y);
          }

          canvas.drawCircle(
            Offset(x, y),
            3,
            pointPaint,
          );

          final textPainter = TextPainter(
            text: TextSpan(
              text: "$i",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
            textDirection: TextDirection.ltr,
          );

          textPainter.layout();

          textPainter.paint(
            canvas,
            Offset(x + 2, y - 8),
          );
        }

        canvas.drawPath(path, paint);
      });
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}