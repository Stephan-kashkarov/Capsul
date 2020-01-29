import 'dart:io';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    List images;
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
              child: Image.file(File(images[index])),
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