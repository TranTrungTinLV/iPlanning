import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iplanning/consts/firebase_const.dart';
import 'package:iplanning/models/Budget.dart';
import 'package:iplanning/models/events_model.dart';
import 'package:uuid/uuid.dart';

class BudgetMethod {
  CollectionReference budgetEvents = firestoreInstance.collection('budgets');
  CollectionReference eventPost = firestoreInstance.collection('eventPosts');

  addBudget({
    required String budget_name,
    List<String>? note_id,
    required double estimate_amount,
    required String event_id,
  }) async {
    String res = 'Budget error';
    try {
      String budgetId = const Uuid().v4().split('-')[0];
      Budget budgetModel = Budget(
        event_id: event_id,
        budget_name: budget_name,
        // budget_id: budgetId,
        note_id: note_id,
        paidAmount: estimate_amount,
      );
      await budgetEvents.doc(budgetId).set(budgetModel.toJson());
      await updateBudgetEventIds(budgetId, event_id);
      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<List<Budget>> loadBudgetwithEvent(String event_id) async {
    try {
      QuerySnapshot snapshot =
          await budgetEvents.where('event_id', isEqualTo: event_id).get();
      print('Documents found: ${snapshot.docs.length}');
      List<Budget> budget = snapshot.docs.map((doc) {
        return Budget.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
      return budget;
    } catch (e, stacktrace) {
      print('Failed to get all: $e');
      print('Stacktrace: $stacktrace');
      return [];
    }
  }

  Future<void> updateBudgetEventIds(String budget_id, String eventId) async {
    try {
      DocumentReference budgetRef = FirebaseFirestore.instance
          .collection('eventPosts')
          .doc(eventId); //Đọc theo id của events để cập nhật budget

      // Instead of adding to an array, update the field with a single String
      await budgetRef.update({
        'budget': FieldValue.arrayUnion(
            [budget_id]) // Directly set the event_id as a String
      });

      print("Updated event_ids with: $eventId");
    } catch (e) {
      print('Error updating event_ids: $e');
    }
  }
}
