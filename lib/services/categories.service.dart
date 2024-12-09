import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iplanning/consts/firebase_const.dart';
import 'package:iplanning/models/categoryClass.dart';
import 'package:uuid/uuid.dart';

class CategoriesMethod {
  CollectionReference categoriesEvent =
      firestoreInstance.collection('categoriesEvent');

  // ! default categories
  Future<void> uploadDefaultCategories() async {
    try {
      // Định nghĩa màu sắc cho các danh mục mặc định
      Map<String, Color> defaultCategories = {
        "Music": Colors.blue,
        "Travel": Colors.green,
        "Food": Colors.orange,
      };

      for (String name in defaultCategories.keys) {
        QuerySnapshot querySnapshot =
            await categoriesEvent.where('name', isEqualTo: name).limit(1).get();

        if (querySnapshot.docs.isEmpty) {
          String category_id = const Uuid().v4().split('-')[0];
          CategoryModel categoryModel = CategoryModel(
            createAt: Timestamp.now(),
            category_id: category_id,
            name: name,
            event_ids: [],
            color: defaultCategories[name]!.value,
          );

          await categoriesEvent.doc(category_id).set(categoryModel.toJson());
        }
      }
    } catch (e) {
      print('Error uploading default categories: $e');
    }
  }

  Future<String> createCategory({
    required String name,
    required Color color,
    List<String>? eventIds,
  }) async {
    String res = 'Some Error';
    try {
      QuerySnapshot querySnapshot =
          await categoriesEvent.where('name', isEqualTo: name).limit(1).get();
      if (querySnapshot.docs.isNotEmpty) {
        // Nếu danh mục đã tồn tại, trả về thông báo lỗi
        res = 'Category already exists';
      } else {
        // Nếu danh mục chưa tồn tại, tạo danh mục mới
        String categoryId = const Uuid().v4().split('-')[0];
        CategoryModel newCategory = CategoryModel(
          category_id: categoryId,
          name: name,
          color: color.value,
          event_ids: eventIds ?? [],
          createAt: Timestamp.now(),
        );

        await categoriesEvent.doc(categoryId).set(newCategory.toJson());
        res = 'successfully';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> updateCategoryEventIds(String categoryId, String eventId) async {
    try {
      QuerySnapshot querySnapshot = await firestoreInstance
          .collection('categoriesEvent')
          .where('event_ids', arrayContains: eventId)
          .get();

      for (var doc in querySnapshot.docs) {
        await doc.reference.update({
          'event_ids': FieldValue.arrayRemove([eventId]),
        });
        print("Removed event $eventId from old category ${doc.id}");
      }
      DocumentReference categoryRef =
          firestoreInstance.collection('categoriesEvent').doc(categoryId);
      await categoryRef.update({
        'event_ids': FieldValue.arrayUnion([eventId]),
      });
      print("Added event $eventId to new category $categoryId");
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
