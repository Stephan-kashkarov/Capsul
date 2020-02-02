import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

import '../database/models.dart';
import '../database/server.dart';

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

class _ViewFinderState extends State<ViewFinder> with TickerProviderStateMixin {
  List<CameraController> _controllers;
  Future<void> _initializeControllerFuture;
  int _currentController;
  IconData _cameraIcon;
  double _bottomBarHeight = 50.0;
  bool _sliderVisible = false;
  bool _filtersVisible = false;
  List<Duration> _sliderDurations = [
    Duration(minutes: 30),
    Duration(days: 1),
    Duration(days: 30),
    Duration(days: 182),
    Duration(days: 365),
  ];
  List<String> _sliderValues = [
    "30 mins",
    "1 day",
    "30 day",
    "6 months",
    "1 year",
  ];
  double _sliderIndex = 0;

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
    _controllers = [
      CameraController(widget.cameras[0], ResolutionPreset.low),
      CameraController(
        // Get second camera if its an option
        (widget.cameras.length > 1)
        ? widget.cameras[1]
        : widget.cameras[0],
        ResolutionPreset.ultraHigh,
      )
    ];
    _currentController = 0;

    initCamera();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void takePhoto() async {
    try {
      // Ensure that the camera is initialized.
      await _initializeControllerFuture;

      // Construct the path where the image should be saved using the
      // pattern package.
      final path = join(
        (await getTemporaryDirectory()).path,
        '${DateTime.now()}.png',
      );

      // Attempt to take a picture and log where it's been saved.
      await _controllers[_currentController].takePicture(path);
      print("Snap!");
      setState(() {
        Photo photo = Photo(
          MemoryImage(File(path).readAsBytesSync()),
          "none",
          DateTime.now().add(_sliderDurations[_sliderIndex.round()])
        );
        PhotoServer.insert(photo);
      });
    } catch (e) {
      print(e);
    }
  }

  void flipCamera() {
    setState(() {
      _currentController = 1 - _currentController;
      initCamera();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Top app bar with flash and switch cameras
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarOpacity: 0.0,
        backgroundColor: Color(0x00ffffff),
        leading: IconButton(
          icon: Icon(Icons.flash_auto),
          onPressed: () {
            return;
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(_cameraIcon),
            onPressed: flipCamera,
          )
        ],
      ),
      // Bottom bar
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.photo_camera),
        onPressed: takePhoto
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color(0x70505050),
        shape: CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: AnimatedSize(
          curve: Curves.fastOutSlowIn,
          duration: Duration(milliseconds: 500),
          vsync: this,
          child: Container(
            height: _bottomBarHeight,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.settings),
                      iconSize: 30.0,
                      onPressed: () => Navigator.pushNamed(context, '/settings'),
                    ),
                    IconButton(
                      icon: Icon(Icons.av_timer),
                      onPressed: () {
                        setState(() {
                          if (_bottomBarHeight == 120.0) {
                            _bottomBarHeight = 50.0;
                            _sliderVisible = false;
                          } else {
                            _bottomBarHeight = 120.0;
                            _sliderVisible = true;
                            _filtersVisible = false;
                          }
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.filter_b_and_w),
                      onPressed: () {
                        setState(() {
                          if (_bottomBarHeight == 120.0) {
                            _bottomBarHeight = 50.0;
                            _filtersVisible = false;
                          } else {
                            _bottomBarHeight = 120.0;
                            _filtersVisible = true;
                            _sliderVisible = false;
                          }
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.filter),
                      iconSize: 30.0,
                      onPressed: () => Navigator.pushNamed(context, '/gallery'),
                    ),
                  ]
                ),
                // Timer slider
                Visibility(
                  visible: _sliderVisible,
                  maintainState: false,
                  child: Slider(
                    value: _sliderIndex,
                    onChanged: (newVal) => setState(() => _sliderIndex = newVal),
                    label: "${_sliderValues[_sliderIndex.round()]}",
                    divisions: _sliderValues.length - 1,
                    min: 0,
                    max: 4
                  ),
                ),
                // Filters
                Visibility(
                  visible: _filtersVisible,
                  maintainState: false,
                  child: Container(
                    width: 50.0,
                    height: 50.0,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 10,
                      itemBuilder: (context, int) {
                        return Container(
                          width: 40.0,
                          height: 40.0,
                          color: Colors.black,
                        );
                      }
                    ),
                  ),
                ),
              ]
            )
          ),
        ),
      ),
      // Body
      body: FutureBuilder<void>(
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
    );
  }
}