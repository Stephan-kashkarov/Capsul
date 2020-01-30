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
  Future<List<Photo>> images;
  @override
  void initState() {
    super.initState();
    images = PhotoServer.getAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gallery")
        
      ),
      body: FutureBuilder(
        future: images,
        builder: (context, snapshot) {
          if (snapshot.hasData){
            var photos = snapshot.data;
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
              ),
              itemCount: photos.length,
              itemBuilder: (BuildContext context, int index) {
                dynamic photo;
                if (photos[index].isCompleted) {
                  return GridTile(
                  child: GestureDetector(
                    child: Image.memory(photos[index].image.bytes),
                    onTap: () async {
                      Navigator.pushNamed(
                        context, '/showImage',
                        arguments: {
                          'filepath': photos[index]
                        }
                      );
                    }
                  ),
                );
                } else {
                  return GridTile(child: Icon(Icons.timer),);
                }
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }
      )
    );
  }
}