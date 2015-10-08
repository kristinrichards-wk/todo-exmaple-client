library todo_example.src.module.actions;

import 'package:w_flux/w_flux.dart';

import 'package:todo_example/service.dart' show Todo;

class TodoActions {
  final Action<Todo> createTodo = new Action();
  final Action<Todo> completeTodo = new Action();
  final Action<Todo> deleteTodo = new Action();
  final Action<Todo> reopenTodo = new Action();
  final Action<Todo> updateTodo = new Action();
}
