library todo_client.src.module.store;

import 'package:todo_sdk/todo_sdk.dart' show Todo, TodoSdk;
import 'package:w_flux/w_flux.dart';

import 'package:todo_client/src/actions.dart' show TodoActions;

class TodoStore extends Store {
  TodoActions _actions;
  String _activeTodoId;
  bool _includeComplete = true;
  bool _includeIncomplete = true;
  bool _includePrivate = true;
  bool _includePublic = true;
  TodoSdk _sdk;
  Map<String, Todo> _todosMap = {};

  TodoStore(TodoActions actions, TodoSdk sdk)
      : _actions = actions,
        _sdk = sdk {
    _actions.createTodo.listen(_createTodo);
    _actions.deleteTodo.listen(_deleteTodo);
    _actions.updateTodo.listen(_updateTodo);

    triggerOnAction(_actions.selectTodo, _selectTodo);

    triggerOnAction(_actions.toggleIncludeComplete, (_) => _includeComplete = !_includeComplete);
    triggerOnAction(
        _actions.toggleIncludeIncomplete, (_) => _includeIncomplete = !_includeIncomplete);
    triggerOnAction(_actions.toggleIncludePrivate, (_) => _includePrivate = !_includePrivate);
    triggerOnAction(_actions.toggleIncludePublic, (_) => _includePublic = !_includePublic);

    _sdk.todoCreated.listen((todo) {
      _todosMap[todo.id] = todo;
      trigger();
    });

    _sdk.todoDeleted.listen((todo) {
      _todosMap.remove(todo.id);
      trigger();
    });

    _sdk.todoUpdated.listen((todo) {
      _todosMap[todo.id] = todo;
      trigger();
    });

    _initialize();
  }

  Todo get activeTodo => _todosMap[_activeTodoId];
  bool get includeComplete => _includeComplete;
  bool get includeIncomplete => _includeIncomplete;
  bool get includePrivate => _includePrivate;
  bool get includePublic => _includePublic;
  List<Todo> get todos {
    List<Todo> complete = [];
    List<Todo> incomplete = [];
    for (var todo in _todosMap.values) {
      if (!_sdk.userCanAccess(todo)) continue;
      if (!includeComplete && todo.isCompleted) continue;
      if (!includeIncomplete && !todo.isCompleted) continue;
      if (!includePrivate && !todo.isPublic) continue;
      if (!includePublic && todo.isPublic) continue;
      todo.isCompleted ? complete.add(todo) : incomplete.add(todo);
    }

    return []..addAll(incomplete.reversed)..addAll(complete.reversed);
  }

  bool canAccess(Todo todo) => _sdk.userCanAccess(todo);

  _createTodo(Todo todo) {
    _sdk.createTodo(todo);
  }

  _deleteTodo(Todo todo) {
    _sdk.deleteTodo(todo.id);
  }

  _selectTodo(Todo todo) {
    _activeTodoId = todo != null ? todo.id : null;
  }

  _updateTodo(Todo todo) {
    _sdk.updateTodo(todo);
  }

  _initialize() async {
    _todosMap = new Map.fromIterable(
        await _sdk.queryTodos(
            includeComplete: true,
            includeIncomplete: true,
            includePrivate: true,
            includePublic: true),
        key: (todo) => todo.id);
    trigger();
  }
}
