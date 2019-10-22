import 'package:todo_sdk/todo_sdk.dart' show Todo;
import 'package:w_flux/w_flux.dart';

class TodoActions {
  final Action<Todo> createTodo = new Action<Todo>();
  final Action<Todo> completeTodo = new Action<Todo>();
  final Action<Todo> deleteTodo = new Action<Todo>();
  final Action<Todo> editTodo = new Action<Todo>();
  final Action<Todo> reopenTodo = new Action<Todo>();
  final Action<Todo> selectTodo = new Action<Todo>();
  final Action<Null> toggleIncludeComplete = new Action<Null>();
  final Action<Null> toggleIncludeIncomplete = new Action<Null>();
  final Action<Null> toggleIncludePrivate = new Action<Null>();
  final Action<Null> toggleIncludePublic = new Action<Null>();
  final Action<Todo> updateTodo = new Action<Todo>();
}
