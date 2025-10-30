import 'package:flutter/material.dart';

class BassStaffAndNotePainter extends CustomPainter {
  final String? note;

  BassStaffAndNotePainter(this.note);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Vẽ 5 đường kẻ khuông nhạc
    double lineSpacing = (size.height - 40) / 4;
    for (int i = 0; i < 5; i++) {
      canvas.drawLine(
        Offset(20, 5 + i * lineSpacing),
        Offset(size.width - 20, 5 + i * lineSpacing),
        paint,
      );
    }
    TextPainter(
      text: const TextSpan(
        text: '\u{1D122}',
        style: TextStyle(
          fontFamily: 'MusicalSymbols',
          fontSize: 80,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )
      ..layout()
      ..paint(canvas, Offset(20, 5 + 2 * lineSpacing - 60));
    // Vẽ nốt nhạc
    if (note != null) {
      final Map<String, double> notePositions = {
        'C': 2.5, // C3 - dòng kẻ 3
        'C#': 2.5, // đúng
        'Db': 2.0, //đã đúng
        'D': 2.0, // đã đúng
        'D#': 2.0, // đã đúng
        'Eb': 1.5, // Eb3 (tương đương E3)
        'E': 1.5, // đã sửa
        'Fb': 1, //đã đúng
        'F': 1.0,
        'F#': 1.0, // đã đúng
        'Gb': 0.5, //đã đúng
        'G': 0.5, // đã đúng
        'G#': 0.5, // đã đúng
        'Ab': -0, //đúng
        'A': 0, // đã đúng
        'A#': -0.5, //đúng
        'Bb': -0.5, // đã sửa
        'B': -0.5, // B3 - trên khuông nhạc, cần đường kẻ phụ
        'Cb': -1.0, // Cb3 (tương đương B3)
        'B#': -0.5,
      };

      // Lấy vị trí nốt nhạc trên khuông nhạc
      final positionIndex = notePositions[note!] ?? 2.0;
      final yPosition = 5 + positionIndex * lineSpacing;

      if (positionIndex > 4.0 || positionIndex < 0.0) {
        // Xác định các đường kẻ phụ cần vẽ
        List<double> auxiliaryLines = [];

        // Nếu nốt nằm dưới khuông nhạc (dưới G2)
        if (positionIndex > 4.0) {
          // Thêm đường kẻ phụ cho các nốt dưới khuông nhạc
          for (double i = 5.0; i <= positionIndex; i += 1.0) {
            if (i.round() == i) {
              auxiliaryLines.add(i);
            }
          }
        }

        // Nếu nốt nằm trên khuông nhạc (trên G3)
        if (positionIndex < 0.0) {
          // Thêm đường kẻ phụ cho các nốt trên khuông nhạc
          for (double i = 0.0; i >= positionIndex; i -= 1.0) {
            if (i.round() == i) {
              auxiliaryLines.add(i);
            }
          }
        }

        // Vẽ các đường kẻ phụ
        for (double linePos in auxiliaryLines) {
          double lineYPosition = 5 + linePos * lineSpacing;
          canvas.drawLine(
            Offset(size.width / 2 - 20, lineYPosition),
            Offset(size.width / 2 + 20, lineYPosition),
            paint,
          );
        }
      }

      // Vẽ nốt (hình elip)
      final notePaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(size.width / 2, yPosition),
          width: 30,
          height: 25,
        ),
        notePaint,
      );

      // Vẽ dấu thăng (#) hoặc giáng (b) bên trái nốt
      if (note!.contains('#') || note!.contains('b')) {
        TextPainter(
          text: TextSpan(
            text: note!.contains('#') ? '\u{266F}' : '\u{266D}',
            style: const TextStyle(
              fontSize: 40,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
        )
          ..layout()
          ..paint(canvas, Offset(size.width / 2 - 45, yPosition - 38));
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
