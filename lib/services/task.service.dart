import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iplanning/consts/firebase_const.dart';
import 'package:iplanning/models/note_models.dart';
import 'package:iplanning/models/todo_models.dart';
import 'package:iplanning/services/note.service.dart';
import 'package:iplanning/utils/todoStatus.dart';
import 'package:iplanning/utils/transactionType.dart';
import 'package:uuid/uuid.dart';

class TodoListMethod {
  CollectionReference todoList = firestoreInstance.collection('todos');
  CollectionReference noteBudget = firestoreInstance.collection('notes');
  createTaskWithTodo(
      {required double amount,
      required String name,
      required Timestamp createAt,
      required String? budget_id,
      required String content,
      required String assignedUserId,
      required String event_ids}) async {
    String res = 'Some Error';
    String? noteId;
    String todoId = const Uuid().v4().split('-')[0];
    if (amount > 0 && budget_id == null) {
      print(
          "Task sẽ được tạo mà không liên kết Budget. Budget sẽ cập nhật sau.");
    }
    if (amount > 0) {
      noteId = const Uuid().v4().split('-')[0];

      NoteModel noteModel = NoteModel(
        note_id: noteId,
        todo_id: todoId,
        name: name,
        createAt: createAt,
        event_ids: event_ids,
        budget_id: budget_id,
        content: content,
        amount: amount,
        transactionType: TransactionType.expense,
      );
      await noteBudget.doc(todoId).set(noteModel.toJson());
      if (budget_id != null) {
        NoteMethod().updateNoteModelwithBudgetIds(noteId, budget_id);
      }
      await updateBudgetEventIds(todoId, event_ids);
    }
    try {
      TodoModel todoModel = TodoModel(
          createAt: createAt,
          assignedUserId: assignedUserId ?? authInstance.currentUser!.uid,
          amount: amount,
          completed: TodoStatus.notStarted,
          details: content,
          note_id: noteId,
          title: name,
          todoId: todoId,
          event_ids: event_ids);
      await todoList.doc(todoId).set(todoModel.toJson());
      await updateBudgetEventIds(todoId, event_ids);
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
          firestoreInstance.collection('budgets').doc(budgetId);
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

  Future<void> updateBudgetEventIds(String todoId, String eventId) async {
    try {
      DocumentReference event =
          firestoreInstance.collection('eventPosts').doc(eventId);

      await event.update({
        'todoList': FieldValue.arrayUnion([todoId])
      });

      print("Updated event_ids with: $eventId");
    } catch (e) {
      print('Error updating event_ids: $e');
    }
  }

  Future<List<TodoModel>> getAllList(String event_id) async {
    try {
      QuerySnapshot snapshot =
          await todoList.where('event_ids', isEqualTo: event_id).get();
      print('Documents found: ${snapshot.docs.length}');
      List<TodoModel> todoModel = snapshot.docs.map((doc) {
        return TodoModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
      return todoModel;
    } catch (e, stacktrace) {
      print('Failed to get all: $e');
      print('Stacktrace: $stacktrace');
      return [];
    }
  }
}
