import 'dart:io';
import 'package:flutter/material.dart';

class ShowImageArugments {
  final String filepath;

  const ShowImageArugments(
    this.filepath
  );
}

class Gallery extends StatefulWidget {
  final List<List<String>> gallery;
  
  const Gallery({
    Key key,
    @required this.gallery,
  }) : super(key : key);

  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  int album;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gallery")
        
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
        ),
        itemCount: widget.gallery[album].length,
        itemBuilder: (BuildContext context, int index) {
          return GridTile(
            child: GestureDetector(
              child: Image.file(File(widget.gallery[album][index])),
              onTap: () async {
                Navigator.pushNamed(
                  context, '/showImage',
                  arguments: {
                    'filepath': widget.gallery[album][index]
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