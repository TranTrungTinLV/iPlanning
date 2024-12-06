import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  String category_id;
  String name;
  int? color;
  Timestamp? createAt;
  List<String>? event_ids;
  CategoryModel({
    required this.category_id,
    required this.event_ids,
    required this.name,
    this.createAt,
    this.color,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      category_id: json['category_id'] as String,
      name: json['name'] as String,
      createAt: json['createAt'] as Timestamp,
      color: json['color'] as int?,
      event_ids: List<String>.from(json['event_ids'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category_id': category_id,
      'name': name,
      'createAt': createAt,
      'event_ids': event_ids,
      'color': color,
    };
  }
}
