import 'dart:async';
import 'package:camera/camera.dart';
import 'package:capsul/gallery.dart';
import 'package:flutter/material.dart';
import 'gallery.dart';
import 'viewfinder.dart';
import 'settings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final c = await availableCameras();
  print(c);
  final List<CameraDescription> cameras = c.sublist(0, 1);

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