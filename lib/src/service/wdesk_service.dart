library todo_example.src.service.wdesk_service;

import 'dart:async';

import 'package:todo_example/src/service/definition.dart' show TodoService;
import 'package:todo_example/src/service/models.dart' show Todo;

class WdeskTodoService implements TodoService {

  /// Create a to-do.
  Future<Todo> createTodo(Todo todo) async {
    return todo;
  }

  /// Delete a to-do.
  Future<Null> deleteTodo(String todoID) async {

  }

  Future<List<Todo>> queryTodos(
      {bool includeComplete: false,
      bool includeIncomplete: false,
      bool includePrivate: false,
      bool includePublic: false}) async {
    return [];
  }

  /// Update a to-do.
  Future<Todo> updateTodo(Todo todo) async {
    return todo;
  }

}