import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iplanning/consts/firebase_const.dart';
import 'package:iplanning/models/note_models.dart';
import 'package:iplanning/models/todoList.dart';
import 'package:iplanning/services/note.dart';
import 'package:iplanning/utils/todoStatus.dart';
import 'package:iplanning/utils/transactionType.dart';
import 'package:uuid/uuid.dart';

class TodoListMethod {
  CollectionReference todoList = firestoreInstance.collection('todos');
  CollectionReference events = firestoreInstance.collection('budgets');
  CollectionReference noteBudget = firestoreInstance.collection('notes');
  createTaskWithTodo({
    required double amount,
    required String name,
    required String budget_id,
    required String content,
  }) async {
    String res = 'Some Error';
    String? noteId;
    String todoId = const Uuid().v4().split('-')[0];
    if (amount > 0) {
      noteId = const Uuid().v4().split('-')[0];
      NoteModel noteModel = NoteModel(
        note_id: noteId,
        todo_id: todoId,
        name: name,
        budget_id: budget_id,
        content: content,
        amount: amount,
        transactionType: TransactionType.expense,
      );

      await noteBudget.doc(todoId).set(noteModel.toJson());
      NoteMethod().updateNoteModelwithBudgetIds(noteId, budget_id);
    }
    try {
      TodoModel todoModel = TodoModel(
          amount: amount,
          budget_id: budget_id,
          completed: TodoStatus.notStarted,
          details: content,
          note_id: noteId,
          title: name,
          todoId: todoId);
      await todoList.doc(todoId).set(todoModel.toJson());
      await updateNoteTodowithBudgetIds(todoId, budget_id);
      res = "success";
    } catch (e) {
      print(e);
    }
    return res;
  }

  Future<void> updateNoteTodowithBudgetIds(
      String todoId, String budgetId) async {
    try {
      DocumentReference budgetRef =
          FirebaseFirestore.instance.collection('budgets').doc(budgetId);
      //
      await budgetRef.update(
        {
          'todoList': FieldValue.arrayUnion([todoId])
        },
      );
      print("Updated event_ids with: $budgetId");
      print("Updated event_ids with: $todoId");
    } catch (e) {
      print('Error updating $budgetId: $e');
    }
  }
}
