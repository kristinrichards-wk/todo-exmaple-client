library todo_example.src.service.definition;

import 'dart:async';

import 'package:todo_example/src/service/models.dart' show Todo;

abstract class TodoService {
  /// Broadcast stream of "to-do created" events.
  Stream<Todo> get todoCreated;

  /// Broadcast stream of "to-do deleted" events.
  Stream<Todo> get todoDeleted;

  /// Broadcast stream of "to-do updated" events.
  Stream<Todo> get todoUpdated;

  /// Create a to-do.
  Future<Todo> createTodo(Todo todo);

  /// Delete a to-do.
  Future<Null> deleteTodo(String todoID);

  /// Query for to-dos.
  Future<List<Todo>> queryTodos(
      {bool includeComplete: false,
      bool includeIncomplete: false,
      bool includePrivate: false,
      bool includePublic: false});

  /// Update a to-do.
  Future<Todo> updateTodo(Todo todo);
}
