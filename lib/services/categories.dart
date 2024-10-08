import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iplanning/consts/firebase_const.dart';
import 'package:iplanning/models/categoryClass.dart';
import 'package:iplanning/models/events_model.dart';
import 'package:uuid/uuid.dart';

class CategoriesMethod {
  CollectionReference categoriesEvent =
      firestoreInstance.collection('categoriesEvent');

  // ! default categories
  Future<void> uploadDefaultCategories() async {
    try {
      List<String> defaultCategoryNames = ["Music", "Travel", "Food"];
      for (String name in defaultCategoryNames) {
        QuerySnapshot querySnapshot =
            await categoriesEvent.where('name', isEqualTo: name).limit(1).get();

        if (querySnapshot.docs.isEmpty) {
          // If the category does not exist, create it
          String category_id = const Uuid().v4().split('-')[0];
          CategoryModel categoryModel = CategoryModel(
            category_id: category_id,
            name: name,
            event_ids: [], // Empty list initially
          );

          await categoriesEvent.doc(category_id).set(categoryModel.toJson());
        }
      }
    } catch (e) {
      print('Error uploading default categories: $e');
    }
  }

  Future<void> updateCategoryEventIds(String categoryId, String eventId) async {
    try {
      DocumentReference categoryRef = FirebaseFirestore.instance
          .collection('categoriesEvent')
          .doc(categoryId);
      print(categoryId);
      await categoryRef.update({
        'event_ids': FieldValue.arrayUnion([eventId])
      });
    } catch (e) {
      print('Error updating event_ids: $e');
    }
  }

// ! user custom by Event_ID
  Future<String> uploadCategories({
    required String event_id,
    required String name,
  }) async {
    String res = 'Some Error';
    try {
      // Check if the category already exists
      QuerySnapshot querySnapshot =
          await categoriesEvent.where('name', isEqualTo: name).limit(1).get();

      if (querySnapshot.docs.isNotEmpty) {
        // Category exists, update the event_ids list
        DocumentSnapshot categoryDoc = querySnapshot.docs.first;
        CategoryModel existingCategory =
            CategoryModel.fromJson(categoryDoc.data() as Map<String, dynamic>);

        // Add the new event_id to the list if it doesn't already exist
        if (existingCategory.event_ids == null) {
          existingCategory.event_ids = [event_id];
        } else if (!existingCategory.event_ids!.contains(event_id)) {
          existingCategory.event_ids!.add(event_id);
        }

        await categoriesEvent
            .doc(existingCategory.category_id)
            .update({'event_ids': existingCategory.event_ids});
        res = 'Success';
      } else {
        // Create a new category with the given event_id
        String category_id = const Uuid().v4().split('-')[0];
        CategoryModel newCategory = CategoryModel(
          category_id: category_id,
          name: name,
          event_ids: [event_id],
        );
        await categoriesEvent.doc(category_id).set(newCategory.toJson());
        res = 'Success';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  getAllCategories() async {}
}
