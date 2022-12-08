import 'package:flutter/material.dart';
import 'package:flutter_generative_art_demo/particle.dart';

class MyPainterCanvas extends CustomPainter {
  List<Particle> particleList;
  MyPainterCanvas({required this.particleList});
  @override
  void paint(Canvas canvas, Size size) {
    particleList.forEach((e) {
      Paint paint = Paint()
        ..color = e.color
        ..blendMode = BlendMode.modulate;
      canvas.drawCircle(e.position, e.radius, paint);
    });
  }

  @override
  bool shouldRepaint(CustomPainter o) {
    return true;
  }
}
