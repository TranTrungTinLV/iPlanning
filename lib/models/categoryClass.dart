import 'package:iplanning/models/events_model.dart';

class CategoryModel {
  String category_id;
  String name;
  // String description;
  List<EventsPostModel>? event_ids;
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
        event_ids: (json['event_ids'] as List)
            .map((eventJson) => EventsPostModel.fromJson(eventJson))
            .toList());
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
