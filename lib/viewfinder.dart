import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

// A screen that allows users to take a picture using a given camera.
class ViewFinder extends StatefulWidget {
  final List<CameraDescription> cameras;

  const ViewFinder({
    Key key,
    @required this.cameras,
  }) : super(key: key);

  @override
  ViewFinderState createState() => ViewFinderState();
}

class ViewFinderState extends State<ViewFinder> {
  List<CameraController> _controllers;
  Future<void> _initializeControllerFuture;
  int _current_controller;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controllers = [
      CameraController(
        // Get a specific camera from the list of available cameras.
        widget.cameras[0],
        // Define the resolution to use.
        ResolutionPreset.ultraHigh,
      ),
      CameraController(
        // Get a specific camera from the list of available cameras.
        widget.cameras[1],
        // Define the resolution to use.
        ResolutionPreset.ultraHigh,
      )
    ];
    _current_controller = 0;

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controllers[_current_controller].initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controllers.forEach((controller) =>controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // If the Future is complete, display the preview.
              return CameraPreview(_controllers[_current_controller]);
            } else {
              // Otherwise, display a loading indicator.
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
        Container(
          child: ButtonBar(
            children: <Widget>[
              Button(),
            ],
          )
        )
      ],
    );
  }
}