import 'package:iplanning/models/events_model.dart';

class CategoryModel {
  String category_id;
  String name;
  // String description;
  List<String>? event_ids;
  CategoryModel({
    required this.category_id,
    required this.event_ids,
    required this.name,
    // required this.description,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      category_id: json['category_id'] as String,
      name: json['name'] as String,
      // description: json['description'] as String,
      event_ids: List<String>.from(json['event_ids'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category_id': category_id,
      'name': name,
      // 'description': description,
      'event_ids': event_ids,
    };
  }
}
