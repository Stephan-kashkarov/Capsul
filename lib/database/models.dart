import 'package:flutter/material.dart';

class Photo {
  int id;
  Image image;
  String filter;
  DateTime targetTime;
  bool isCompleted;

  Photo(this.id, this.image, this.filter, this.targetTime);

  Photo.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.image = Image.memory(json['image']);
    this.filter = json['filter'];
    this.targetTime = DateTime.parse(json['targetTime']);
    this.isCompleted = json['isCompleted'] == 1;
  }
}