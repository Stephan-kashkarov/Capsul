import 'dart:async';
import 'dart:ffi';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'viewfinder.dart';

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
        '/viewfinder': ViewFinder(cameras: cameras),
        '/gallery': Void,
        '/settings': Void
      },
    )
  );

}