import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:background_fetch/background_fetch.dart';

import 'pages/gallery.dart';
import 'pages/viewfinder.dart';
import 'pages/settings.dart';
import 'database/database.dart';
import 'services/background.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initalises database
  await DatabaseFactory().initDatabase();
  // Processes Background task config
  await initBackgroundState();
  // Gets list of cameras
  final allCameras = await availableCameras();
  final List<CameraDescription> cameras = [];

  // Selects one or two cameras
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

  // launches headless task
  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
}