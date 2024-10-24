import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iplanning/consts/firebase_const.dart';
import 'package:iplanning/models/note.dart';
import 'package:iplanning/models/todoList.dart';
import 'package:iplanning/services/todoList.dart';
import 'package:iplanning/utils/todoStatus.dart';
import 'package:iplanning/utils/transactionType.dart';
import 'package:uuid/uuid.dart';

class NoteMethod {
  CollectionReference noteBudget = firestoreInstance.collection('notes');
  CollectionReference budgetEvents = firestoreInstance.collection('budgets');
  CollectionReference todoList = firestoreInstance.collection('todos');

  addNote({
    required String name,
    required String budget_id,
    required String content,
    required double amount,
    required TransactionType transactionType,
  }) async {
    String res = 'Some Error';
    try {
      String noteId = const Uuid().v4().split('-')[0];
      String? todoId;
      if (transactionType == TransactionType.expense) {
        todoId = const Uuid().v4().split('-')[0];
        TodoModel todoModel = TodoModel(
            amount: amount,
            budget_id: budget_id,
            completed: TodoStatus.notStarted,
            details: content,
            note_id: noteId,
            title: name,
            todoId: todoId);
        await todoList.doc(todoId).set(todoModel.toJson());
        await TodoListMethod().updateNoteTodowithBudgetIds(todoId, budget_id);
      }
      NoteModel noteModel = NoteModel(
          name: name,
          amount: amount,
          budget_id: budget_id,
          transactionType: transactionType,
          content: content,
          todo_id: '',
          note_id: noteId);
      await noteBudget.doc(noteId).set(noteModel.toJson());
      await updateNoteModelwithBudgetIds(noteId, budget_id);
      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<List<NoteModel>> loadNoteModelwithBudget(String budgetId) async {
    try {
      QuerySnapshot snapshot =
          await noteBudget.where('budget_id', isEqualTo: budgetId).get();
      print('Documents found: ${snapshot.docs.length}');
      List<NoteModel> noteModel = snapshot.docs.map((doc) {
        return NoteModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
      return noteModel;
    } catch (e, stacktrace) {
      print('Failed to get all: $e');
      print('Stacktrace: $stacktrace');
      return [];
    }
  }

  // ! updateNotewithBudgetsIds
  Future<void> updateNoteModelwithBudgetIds(
      String note_id, String budgetId) async {
    try {
      DocumentReference budgetRef =
          FirebaseFirestore.instance.collection('budgets').doc(budgetId);
      //
      await budgetRef.update(
        {
          'note_id': FieldValue.arrayUnion([note_id])
        },
      );
      print("Updated event_ids with: $budgetId");
      print("Updated event_ids with: $note_id");
    } catch (e) {
      print('Error updating $budgetId: $e');
    }
  }
}
