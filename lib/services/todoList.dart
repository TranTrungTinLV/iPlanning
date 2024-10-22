import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iplanning/consts/firebase_const.dart';
import 'package:iplanning/models/todoList.dart';
import 'package:iplanning/utils/todoStatus.dart';
import 'package:uuid/uuid.dart';

class TodoListMethod {
  CollectionReference todoList = firestoreInstance.collection('todos');
  CollectionReference events = firestoreInstance.collection('eventPosts');
  addTodo({
    required String title,
    required TodoStatus completed,
    required String details,
    required String event_id,
    required double amount,
  }) async {
    String res = 'Todo error';
    try {
      String todoId = const Uuid().v4().split('-')[0];
      TodoModel todoModel = TodoModel(
          title: title,
          completed: completed,
          details: details,
          event_id: event_id,
          todoId: todoId,
          amount: amount);
      await todoList.doc(todoId).set(todoModel.toJson());
      await updateBTodoEventIds(todoId, event_id);
      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> updateBTodoEventIds(String todoId, String eventId) async {
    try {
      DocumentReference budgetRef = FirebaseFirestore.instance
          .collection('eventPosts')
          .doc(eventId); //Đọc theo id của events để cập nhật budget

      await budgetRef.update({
        'todoList': FieldValue.arrayUnion([todoId]),
      });

      print("Updated event_ids with: $eventId");
    } catch (e) {
      print('Error updating event_ids: $e');
    }
  }
}
