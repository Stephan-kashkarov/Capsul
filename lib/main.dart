import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'pages/gallery.dart';
import 'pages/viewfinder.dart';
import 'pages/settings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final allCameras = await availableCameras();
  final List<CameraDescription> cameras = allCameras.sublist(0, 2);

  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      initialRoute: "/viewfinder",
      routes: {
        '/viewfinder': (context) => ViewFinder(cameras: cameras),
        '/gallery': (context) => Gallery(),
        '/settings': (context) => Settings(),
      },
    )
  );
}