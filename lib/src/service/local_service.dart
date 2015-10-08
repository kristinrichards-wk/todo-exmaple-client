library todo_example.src.service.local_service;

import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:uuid/uuid.dart';

import 'package:todo_example/src/service/definition.dart' show TodoService;
import 'package:todo_example/src/service/models.dart' show Todo;

class LocalTodoService implements TodoService {
  static const String _localStorageKey = 'link-2015-todo-example-todos';

  Map<String, Todo> _todos;
  Uuid _uuid = new Uuid();

  LocalTodoService() {
    _loadTodos();
  }

  /// Create a to-do.
  Future<Todo> createTodo(Todo todo) async {
    var map = todo.toMap();
    map['id'] = _uuid.v4();
    Todo created = new Todo.fromMap(map);
    _todos[created.id] = created;
    _writeTodos();
    return created;
  }

  /// Delete a to-do.
  Future<Null> deleteTodo(String todoID) async {
    Todo toDelete = _todos[todoID];
    if (toDelete == null) throw new Exception('404');
    _todos.remove(todoID);
    _writeTodos();
  }

  /// Query for to-dos.
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
  Future<Todo> updateTodo(Todo todo) async {
    _todos[todo.id] = todo;
    _writeTodos();
    return todo;
  }

  void _loadTodos() {
    _todos = {};
    if (window.localStorage.containsKey(_localStorageKey)) {
      Map<String, Map> source =
          JSON.decode(window.localStorage[_localStorageKey]);

      source.forEach((id, todoMap) {
        _todos[id] = new Todo.fromMap(todoMap);
      });
    }
  }

  void _writeTodos() {
    Map json = {};
    _todos.forEach((key, todo) {
      json[key] = todo.toMap();
    });
    window.localStorage[_localStorageKey] = JSON.encode(json);
  }
}
