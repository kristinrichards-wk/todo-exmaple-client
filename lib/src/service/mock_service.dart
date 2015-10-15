library todo_example.src.service.mock_service;

import 'dart:async';

import 'package:uuid/uuid.dart';

import 'package:todo_example/src/service/definition.dart' show TodoService;
import 'package:todo_example/src/service/models.dart' show Todo;

class MockTodoService implements TodoService {
  StreamController<Todo> _todoCreated = new StreamController.broadcast();
  StreamController<Todo> _todoDeleted = new StreamController.broadcast();
  StreamController<Todo> _todoUpdated = new StreamController.broadcast();

  Map<String, Todo> _todos = {};
  Uuid _uuid = new Uuid();

  @override
  Stream<Todo> get todoCreated => _todoCreated.stream;

  @override
  Stream<Todo> get todoDeleted => _todoDeleted.stream;

  @override
  Stream<Todo> get todoUpdated => _todoUpdated.stream;

  /// Create a to-do.
  @override
  Future<Todo> createTodo(Todo todo) async {
    var map = todo.toMap();
    map['id'] = _uuid.v4();
    Todo created = new Todo.fromMap(map);
    _todos[created.id] = created;
    _todoCreated.add(created);
    return created;
  }

  /// Delete a to-do.
  @override
  Future<Null> deleteTodo(String todoID) async {
    Todo toDelete = _todos[todoID];
    if (toDelete == null) throw new Exception('404');
    _todos.remove(todoID);
    _todoDeleted.add(toDelete);
  }

  /// Query for to-dos.
  @override
  Future<List<Todo>> queryTodos(
      {bool includeComplete: false,
      bool includeIncomplete: false,
      bool includePrivate: false,
      bool includePublic: false}) async {
    if (!includeComplete &&
        !includeIncomplete &&
        !includePrivate &&
        !includePublic) return [];

    List<Todo> todos = [];
    for (var todo in _todos.values) {
      if (!includeComplete && todo.isCompleted) continue;
      if (!includeIncomplete && /*incomplete */ !todo.isCompleted) continue;
      if (!includePrivate && /* private */ !todo.isPublic) continue;
      if (!includePublic && todo.isPublic) continue;
      todos.add(todo);
    }

    return todos;
  }

  /// Update a to-do.
  @override
  Future<Todo> updateTodo(Todo todo) async {
    _todos[todo.id] = todo;
    _todoUpdated.add(todo);
    return todo;
  }
}
