library todo_example.src.module.store;

import 'package:todo_example/service.dart' show Todo, TodoService;
import 'package:w_flux/w_flux.dart';

import 'package:todo_example/src/module/actions.dart' show TodoActions;

class TodoStore extends Store {
  TodoActions _actions;
  String _activeTodoId;
  bool _includeComplete = true;
  bool _includeIncomplete = true;
  bool _includePrivate = true;
  bool _includePublic = true;
  TodoService _service;
  Map<String, Todo> _todosMap = {};

  TodoStore(TodoActions actions, TodoService service)
      : _actions = actions,
        _service = service {
    _actions.createTodo.listen(_createTodo);
    _actions.deleteTodo.listen(_deleteTodo);
    _actions.updateTodo.listen(_updateTodo);

    triggerOnAction(_actions.selectTodo, _selectTodo);

    triggerOnAction(_actions.toggleIncludeComplete,
        (_) => _includeComplete = !_includeComplete);
    triggerOnAction(_actions.toggleIncludeIncomplete,
        (_) => _includeIncomplete = !_includeIncomplete);
    triggerOnAction(_actions.toggleIncludePrivate,
        (_) => _includePrivate = !_includePrivate);
    triggerOnAction(
        _actions.toggleIncludePublic, (_) => _includePublic = !_includePublic);

    _service.todoCreated.listen((todo) {
      _todosMap[todo.id] = todo;
      trigger();
    });

    _service.todoDeleted.listen((todo) {
      _todosMap.remove(todo.id);
      trigger();
    });

    _service.todoUpdated.listen((todo) {
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
      if (!includeComplete && todo.isCompleted) continue;
      if (!includeIncomplete && !todo.isCompleted) continue;
      if (!includePrivate && !todo.isPublic) continue;
      if (!includePublic && todo.isPublic) continue;
      todo.isCompleted ? complete.add(todo) : incomplete.add(todo);
    }

    return []..addAll(incomplete.reversed)..addAll(complete.reversed);
  }

  _createTodo(Todo todo) {
    _service.createTodo(todo);
  }

  _deleteTodo(Todo todo) {
    _service.deleteTodo(todo.id);
  }

  _selectTodo(Todo todo) {
    _activeTodoId = todo != null ? todo.id : null;
  }

  _updateTodo(Todo todo) {
    _service.updateTodo(todo);
  }

  _initialize() async {
    _todosMap = new Map.fromIterable(
        await _service.queryTodos(
            includeComplete: true,
            includeIncomplete: true,
            includePrivate: true,
            includePublic: true),
        key: (todo) => todo.id);
    trigger();
  }
}
