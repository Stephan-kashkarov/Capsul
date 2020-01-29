import 'database.dart';
import 'models.dart';
// import 'dart:async';

class PhotoServer {

  static Future<List<Photo>> getAll() async {
    final data = await db.rawQuery('SELECT * FROM photos');

    List<Photo> photos = List();

    for (final node in data) {
      Photo photo = Photo.fromJson(node);
      photos.add(photo);
    }
    return photos;
  }

  static Future<Photo> getOne(int id) async {
    List<dynamic> params = [id];
    final data = await db.rawQuery('SELECT * FROM photos WHERE id = ?', params);

    return Photo.fromJson(data.first);
  }

  static Future<void> insert(Photo photo) async {
    Map<String, dynamic> data = photo.toJson();

    final sql = """
    INSERT INTO photos 
    (
      id,
      image,
      filter,
      targetTime,
      isCompleted
    )
    VALUES
    (?,?,?,?,?)
    """;
  }
}