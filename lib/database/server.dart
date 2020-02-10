import 'database.dart';
import 'models.dart';
// import 'dart:async';

class PhotoServer {

  static Future<List<Photo>> getAll() async {
    final data = await db.rawQuery(
      """
      SELECT *
      FROM photos
      """
    );

    List<Photo> photos = List();

    for (final node in data) {
      Photo photo = Photo.fromJson(node);
      photos.add(photo);
    }
    return photos;
  }

  static Future<Photo> getOne(int id) async {
    List<dynamic> params = [id];
    final data = await db.rawQuery(
      """
      SELECT *
      FROM photos
      WHERE id = ?
      """,
      params
    );

    return Photo.fromJson(data.first);
  }

  static Future<void> insert(Photo photo) async {
    Map<String, dynamic> data = photo.toJson();

    var sql = """
      INSERT INTO photos 
      (
        image,
        filter,
        targetTime,
        isCompleted
      )
      VALUES
      (?,?,?,?)
      """;
    List<dynamic> params = [
      data['image'],
      data['filter'],
      data['targetTime'],
      data['isCompleted']
    ];
    final response = await db.rawInsert(sql, params);
    DatabaseFactory.log('Add Photo', sql, null, response, params);
  }

  static Stream<Photo> getActive() async* {
    final data = await db.rawQuery(
      """
      SELECT *
      FROM photos
      WHERE isCompleted = 0
      """
    );
    for (final node in data) {
      yield Photo.fromJson(node);
    }
  }

  static Future<void> update(int id) async {
    var sql = """
    UPDATE photos
    SET isCompleted = 1
    WHERE id = ?
    """;

    final response = await db.rawUpdate(sql, [id]);
    DatabaseFactory.log('Update Photo', sql, null, response, [id]);
  } 
  
}