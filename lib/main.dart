import 'dart:async';
import 'dart:ffi';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  print(cameras);
  final firstCamera = cameras.first;

  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      initialRoute: "/viewfinder",
      routes: {
        '/viewfinder': Widget,
        '/gallery': Void,
        '/settings': Void
      },
    )
  );

}