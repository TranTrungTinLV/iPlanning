import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iplanning/consts/firebase_const.dart';
import 'package:iplanning/models/categoryClass.dart';
import 'package:uuid/uuid.dart';

class CategoriesMethod {
  CollectionReference categoriesEvent =
      firestoreInstance.collection('categoriesEvent');
  final Map<String, Color> defaultCategories = {
    "Music": Colors.blue,
    "Travel": Colors.green,
    "Food": Colors.orange,
  };
  // ! default categories
  Future<void> uploadDefaultCategories() async {
    try {
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

  // ! delete Categories
  Future<bool> deleteCategorires(String categoryId) async {
    try {
      DocumentSnapshot categoryDoc =
          await categoriesEvent.doc(categoryId).get();
      if (categoryDoc.exists) {
        Map<String, dynamic>? data =
            categoryDoc.data() as Map<String, dynamic>?;
        List<dynamic>? eventIds = data?['event_ids'];
        String? categoryName = data?['name'];

        // Check if the category is a default category
        if (defaultCategories.containsKey(categoryName)) {
          Fluttertoast.showToast(
              msg: "Không thể xóa danh mục mặc định.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.grey.shade600,
              textColor: Colors.white,
              fontSize: 16.0);
          return false; // Cannot delete default categories
        }

        // Check if the category has no events
        if (eventIds == null || eventIds.isEmpty) {
          await categoriesEvent.doc(categoryId).delete();
          Fluttertoast.showToast(
              msg: "Danh mục đã xóa thành công.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.grey.shade600,
              textColor: Colors.white,
              fontSize: 16.0);
          return true; // Successfully deleted
        } else {
          Fluttertoast.showToast(
              msg: "Không thể xóa danh mục. Vẫn còn kế hoạch trong đây.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.grey.shade600,
              textColor: Colors.white,
              fontSize: 16.0);
          return false; // Cannot delete if events exist
        }
      }
      return false; // Category not found
    } catch (e) {
      print('Lỗi khi xóa danh mục: $e');
      return false; // Error occurred
    }
  }
}
