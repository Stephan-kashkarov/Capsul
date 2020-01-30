import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'pages/gallery.dart';
import 'pages/viewfinder.dart';
import 'pages/settings.dart';
import 'database/database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseFactory().initDatabase();
  final allCameras = await availableCameras();
  final List<CameraDescription> cameras = [];
  if (allCameras.length > 1) {
    cameras.addAll(allCameras.sublist(0, 2));
  } else {
    cameras.add(allCameras.first);
  }

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