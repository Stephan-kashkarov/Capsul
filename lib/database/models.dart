import 'package:intl/intl.dart';
import 'package:flutter/material.dart';


class Photo {
  int id;
  MemoryImage image;
  String filter;
  DateTime targetTime;
  DateTime takenTime;
  bool isCompleted = false;

  DateFormat format = DateFormat("yyyy-MM-dd HH:mm:ss");

  Photo(this.image, this.filter, this.targetTime);

  Photo.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.image = MemoryImage(json['image']);
    this.filter = json['filter'];
    this.targetTime = DateTime.parse(json['targetTime']);
    this.isCompleted = json['isCompleted'] == 1;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'id': this.id,
      'image': this.image.bytes,
      'filter': this.filter,
      'takenTime': format.format(this.takenTime),
      'targetTime': format.format(this.targetTime),
      'isCompleted': (this.isCompleted == true) ? 1 : 0,
    };
    return json;
  }
}