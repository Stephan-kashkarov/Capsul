import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

// A screen that allows users to take a picture using a given camera.
class ViewFinder extends StatefulWidget {
  final List<CameraDescription> cameras;

  const ViewFinder({
    Key key,
    @required this.cameras,
  }) : super(key: key);

  @override
  _ViewFinderState createState() => _ViewFinderState();
}

class _ViewFinderState extends State<ViewFinder> {
  List<CameraController> _controllers;
  Future<void> _initializeControllerFuture;
  int _currentController;
  IconData _cameraIcon;
  String thumbnail;

  void initCamera() {
    /*
      Init camera function

      This function initalises the given camera depending on which camera 
      is currently selected by the widget
    */
    if (_currentController == 1) {
      _cameraIcon = Icons.camera_front;
    } else {
      _cameraIcon = Icons.camera_rear;
    }
    _initializeControllerFuture = _controllers[_currentController].initialize();
  }

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
    _currentController = 0;

    // Next, initialize the controller. This returns a Future.
    initCamera();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controllers.forEach((controller) => controller.dispose());
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
              return CameraPreview(_controllers[_currentController]);
            } else {
              // Otherwise, display a loading indicator.
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
        Container(
          child: ButtonBar(
            children: <Widget>[
              IconButton(
                icon: Icon(_cameraIcon),
                onPressed: () async {
                  setState(() {
                    _currentController = 1 - _currentController;
                    initCamera();
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.camera_alt),
                onPressed: () async {
                  try {
                    // Ensure that the camera is initialized.
                    await _initializeControllerFuture;

                    // Construct the path where the image should be saved using the
                    // pattern package.
                    final path = join(
                      // Store the picture in the temp directory.
                      // Find the temp directory using the `path_provider` plugin.
                      (await getTemporaryDirectory()).path,
                      '${DateTime.now()}.png',
                    );

                    // Attempt to take a picture and log where it's been saved.
                    await _controllers[_currentController].takePicture(path);
                    setState(() {
                      thumbnail = path;
                    });
                    // If the picture was taken, display it on a new screen.
                  } catch (e) {
                    // If an error occurs, log the error to the console.
                    print(e);
                  }
                },
              ),
              FlatButton(
                child: Image.file(File(thumbnail)),
                onPressed: () => Navigator.pushNamed(context, '/gallery'),
              )
            ],
          )
        )
      ],
    );
  }
}