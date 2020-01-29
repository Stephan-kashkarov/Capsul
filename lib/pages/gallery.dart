import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../database/server.dart';
import '../database/models.dart';

class ShowImageArugments {
  final String filepath;

  const ShowImageArugments(
    this.filepath
  );
}

class Gallery extends StatefulWidget {
  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {

  List<Photo> getPhotos() {
    List<Photo> returnVal = [];
    PhotoServer.getAll().then((photos) => returnVal.addAll(photos));
    return returnVal;
  }

  @override
  Widget build(BuildContext context) {
    List<Photo> images = getPhotos();
    return Scaffold(
      appBar: AppBar(
        title: Text("Gallery")
        
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
        ),
        itemCount: images.length,
        itemBuilder: (BuildContext context, int index) {
          return GridTile(
            child: GestureDetector(
              child: Image.memory(images[index].image.bytes),
              onTap: () async {
                Navigator.pushNamed(
                  context, '/showImage',
                  arguments: {
                    'filepath': images[index]
                  }
                );
              }
            ),
          );
        },
      )
    );
  }
}