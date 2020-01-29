import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'pages/gallery.dart';
import 'pages/viewfinder.dart';
import 'pages/settings.dart';
import 'database/database.dart';
import 'database/models.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final allCameras = await availableCameras();
  final List<CameraDescription> cameras = allCameras.sublist(0, 2);

  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      initialRoute: "/viewfinder",
      routes: {
        '/viewfinder': (context) => ViewFinder(db: server, cameras: cameras),
        '/gallery': (context) => Gallery(db: server),
        '/settings': (context) => Settings(),
      },
    )
  );
}