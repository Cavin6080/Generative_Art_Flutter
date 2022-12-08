import 'package:flutter/material.dart';

class Particle {
  Particle({
    required this.position,
    required this.radius,
    required this.color,
    this.theta,
    required this.origin,
  });
  Offset position;
  Offset origin;
  double radius;
  double? theta;
  Color color;
}
