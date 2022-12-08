import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_generative_art_demo/painter/custom_canvas.dart';
import 'package:flutter_generative_art_demo/particle.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geometric Pattern Custom Painter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: const [CustomPaintScreen()],
      ),
    );
  }
}

class CustomPaintScreen extends StatefulWidget {
  const CustomPaintScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<CustomPaintScreen> createState() => _CustomPaintState();
}

class _CustomPaintState extends State<CustomPaintScreen>
    with SingleTickerProviderStateMixin {
  late List<Particle> particleList;
  late Animation<double> animation;
  late AnimationController animationController;

  @override
  void initState() {
    particleList = [];
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );
    animation = Tween<double>(begin: 0, end: 300).animate(animationController)
      ..addListener(() {
        if (particleList.isEmpty) {
          //create
          createBlobField();
        } else {
          //update
          setState(() {
            updateBlobField();
          });
        }
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          animationController.repeat();
        } else if (status == AnimationStatus.dismissed) {
          animationController.forward();
        }
      });
    animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomPaint(
          painter: MyPainterCanvas(particleList: particleList),
          child: Container(),
        ),
      ],
    );
  }

  void createBlobField() {
    final Size size = MediaQuery.of(context).size;
    int n = 3; //number of blobs

    final Offset o = Offset(
      size.width / 2,
      size.height / 2,
    ); // center of screen

    double r = size.width / n; //radius of blob
    const double a = 0.5; //alpha blending value

    blobField(r, n, a, o);
  }

  void blobField(double r, int n, double a, Offset o) {
    if (r < 10) return;
    //center big blog
    particleList.add(
      Particle(
        color: Colors.black,
        position: o,
        radius: r / n,
        origin: o,
        theta: 0,
      ),
    );

    //orbitals
    double theta = 0.0; //angle of arc
    double dtheta = 2 * pi / n; //angle between child blobs

    for (var i = 0; i < n; i++) {
      //first get postion of child blob
      Offset position = Offset(r * cos(theta), r * sin(theta)) + o; //convert
      //polar to cartesian
      particleList.add(
        Particle(
          position: position,
          radius: r / n,
          color: Color((Random().nextDouble() * 0xFFFFFF).toInt())
              .withOpacity(1.0),
          theta: theta,
          origin: o,
        ),
      );
      //increment the angle
      theta += dtheta;
      // double f = 1;
      double f = 0.43;
      blobField(r * f, n, a * 1.5, position);
    }
  }

  double t = 0;
  double dt = 0.04;
  void updateBlobField() {
    double radiusFactor = 5;
    // debugPrint("In update");
    //move the particles in the orbit
    t += dt;
    radiusFactor = updateRadiusFactor(sin(t), -1, 1, 2, 10);
    particleList.forEach((e) {
      e.position = Offset(
            (e.radius * radiusFactor) * cos(e.theta! + t),
            (e.radius * radiusFactor) * sin(e.theta! + t),
          ) +
          e.origin;
    });
  }

  updateRadiusFactor(
    double value,
    double min1,
    double max1,
    double min2,
    double max2,
  ) {
    double range1 = min1 - max1;
    double range2 = min2 - max2;
    return min2 + range2 * value / range1;
  }
}
