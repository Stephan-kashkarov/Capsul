import 'package:flutter/material.dart';
import '../database/models.dart';
import '../database/server.dart';
import 'dart:io';
import 'package:photo_view/photo_view.dart';


class ShowImage extends StatefulWidget {
  final int id;

  const ShowImage({
    Key key,
    @required this.id,
  }) : super(key: key);

  @override
  ShowImageState createState() => ShowImageState();
}

class ShowImageState extends State<ShowImage> {
  Future<Photo> image;

  @override
  void initState() {
    super.initState();
    image = PhotoServer.getOne(widget.id);
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      drawer: Drawer(
        child: ListView.builder(
          itemBuilder: (context, i) {
            return ListTile(
              title: Text(""),
            );
          },

        ),
      ),
      body: FutureBuilder(
        future: image,
        builder: (context, snapshot)  {
          if (snapshot.hasData) {
            var photo = snapshot.data;
            return PhotoView(
              imageProvider: MemoryImage(photo.image.bytes),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      )
    );
  }
}