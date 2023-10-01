import 'package:flutter/material.dart';

class ImageModel {
  final int pointId;
  final String path;
  final int id;

  ImageModel({
    required this.pointId,
    required this.path,
    required this.id,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      pointId: json['pointId'],
      path: json['path'],
      id: json['id'],
    );
  }
}

class PointFVO {
  final double longitude;
  final double latitude;
  final String annotation;
  final int animalId;

  PointFVO({
    required this.longitude,
    required this.latitude,
    required this.annotation,
    required this.animalId,
  });

  factory PointFVO.fromJson(Map<String, dynamic> json) {
    return PointFVO(
      longitude: json['localization']['longitude'] as double,
      latitude: json['localization']['latitude'] as double,
      annotation: json['annotation'] as String,
      animalId: json['animalId'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'localization': {
        'longitude': longitude,
        'latitude': latitude,
      },
      'annotation': annotation,
      'animalId': animalId,
    };
  }
}

class Point {
  final int id;
  final int authorId;
  final int animalId;
  final double longitude;
  final double latitude;
  final String? annotation;
  final String added;
  final String activeUntil;
  final Author author;
  final Animal animal;
  final List<ImageModel> images;

  Point({
    required this.id,
    required this.authorId,
    required this.animalId,
    required this.longitude,
    required this.latitude,
    required this.annotation,
    required this.added,
    required this.activeUntil,
    required this.author,
    required this.animal,
    required this.images,
  });

  factory Point.fromJson(Map<String, dynamic> json) {
    var imageList = json['images'] as List<dynamic>;
    var imageModels =
        imageList.map((imageJson) => ImageModel.fromJson(imageJson)).toList();

    return Point(
      id: json['id'],
      authorId: json['authorId'],
      animalId: json['animalId'],
      longitude: json['longitude'],
      latitude: json['latitude'],
      annotation: json['annotation'],
      added: json['added'],
      activeUntil: json['activeUntil'],
      author: Author.fromJson(json['author']),
      animal: Animal.fromJson(json['animal']),
      images: imageModels,
    );
  }
}

class Author {
  final int id;
  final String firstName;
  final String lastName;
  final String userName;
  final String email;

  Author({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.email,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      userName: json['userName'],
      email: json['email'],
    );
  }
}

class Animal {
  final int id;
  final String name;
  final int threatLevel;

  Animal({
    required this.id,
    required this.name,
    required this.threatLevel,
  });

  factory Animal.fromJson(Map<String, dynamic> json) {
    return Animal(
      id: json['id'],
      name: json['name'],
      threatLevel: json['threatLevel'],
    );
  }
}
