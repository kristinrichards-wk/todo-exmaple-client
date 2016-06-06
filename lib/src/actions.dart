import 'package:todo_sdk/todo_sdk.dart' show Todo;
import 'package:w_flux/w_flux.dart';

class TodoActions {
  final Action<Todo> createTodo = new Action();
  final Action<Todo> completeTodo = new Action();
  final Action<Todo> deleteTodo = new Action();
  final Action<Todo> editTodo = new Action();
  final Action<Todo> reopenTodo = new Action();
  final Action<Todo> selectTodo = new Action();
  final Action toggleIncludeComplete = new Action();
  final Action toggleIncludeIncomplete = new Action();
  final Action toggleIncludePrivate = new Action();
  final Action toggleIncludePublic = new Action();
  final Action<Todo> updateTodo = new Action();
}