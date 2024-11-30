import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iplanning/consts/firebase_const.dart';
import 'package:iplanning/models/Budget.dart';
import 'package:uuid/uuid.dart';

class BudgetMethod {
  CollectionReference budgetEvents = firestoreInstance.collection('budgets');
  CollectionReference eventPost = firestoreInstance.collection('eventPosts');
  CollectionReference todoList = firestoreInstance.collection('todos');
  CollectionReference noteBudget = firestoreInstance.collection('notes');

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
        budget_id: budgetId,
        note_id: note_id,
        paidAmount: estimate_amount,
      );
      await budgetEvents.doc(budgetId).set(budgetModel.toJson());
      await findTaskOnBudget(budgetId, event_id);
      await updateBudgetEventIds(budgetId, event_id);
      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<Budget?> loadBudgetwithEvent(String event_id) async {
    try {
      QuerySnapshot snapshot =
          await budgetEvents.where('event_id', isEqualTo: event_id).get();
      print('Documents found: ${snapshot.docs.length}');
      Budget budget =
          Budget.fromJson(snapshot.docs.first.data() as Map<String, dynamic>);

      return budget;
    } catch (e, stacktrace) {
      print('Failed to get all: $e');
      print('Stacktrace: $stacktrace');
      return null;
    }
  }

  Future<void> updateBudgetEventIds(String budget_id, String eventId) async {
    try {
      DocumentReference budgetRef =
          firestoreInstance.collection('eventPosts').doc(eventId);

      await budgetRef.update({
        'budget': budget_id,
      });

      print("Updated event_ids with: $eventId");
    } catch (e) {
      print('Error updating event_ids: $e');
    }
  }

  Future<void> findTaskOnBudget(String budget_id, String event_ids) async {
    try {
      // Fetch all notes for the event with budget_id = null
      QuerySnapshot notes = await noteBudget
          .where('event_ids', isEqualTo: event_ids)
          .where('budget_id', isNull: true)
          .get();

      List<String> noteIds = [];

      for (var note in notes.docs) {
        // Cập nhật budget_id trong từng tài liệu notes
        await noteBudget.doc(note.id).update({'budget_id': budget_id});
        noteIds.add(note.id); // Thêm note_id vào danh sách
        print("Note ${note.id} đã được liên kết với Budget ${budget_id}.");
      }

      // Cập nhật lại danh sách note_id trong tài liệu budgets
      if (noteIds.isNotEmpty) {
        await budgetEvents.doc(budget_id).update({
          'note_id': FieldValue.arrayUnion(noteIds),
        });
        print("Cập nhật danh sách note_id vào budget ${budget_id}: $noteIds");
      }

      print("Hoàn thành liên kết task và notes vào budget.");
    } catch (e) {
      print('Lỗi khi cập nhật budget cho task/notes: $e');
    }
  }
}
