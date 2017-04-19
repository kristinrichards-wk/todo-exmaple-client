import 'package:todo_sdk/todo_sdk.dart' show Todo, TodoSdk;
import 'package:truss/modal_manager.dart';
import 'package:w_flux/w_flux.dart';

import 'package:todo_client/src/actions.dart' show TodoActions;
import 'package:todo_client/src/components/edit_todo_modal.dart';

class TodoStore extends Store {
  final TodoActions _actions;
  final TodoSdk _sdk;
  final ModalManager _modalManager;

  String _activeTodoId;
  bool _includeComplete = true;
  bool _includeIncomplete = true;
  bool _includePrivate = true;
  bool _includePublic = true;

  Map<String, Todo> _todosMap = {};

  TodoStore(TodoActions actions, TodoSdk sdk, ModalManager modalManager)
      : _actions = actions,
        _sdk = sdk,
        _modalManager = modalManager {
    manageActionSubscription(_actions.createTodo.listen(_createTodo));
    manageActionSubscription(_actions.deleteTodo.listen(_deleteTodo));
    manageActionSubscription(_actions.editTodo.listen(_editTodo));
    manageActionSubscription(_actions.updateTodo.listen(_updateTodo));

    triggerOnAction(_actions.selectTodo, _selectTodo);

    triggerOnAction(_actions.toggleIncludeComplete, (_) {
      _includeComplete = !_includeComplete;
      // One of these should be true at any given time, or nothing will be displayed.
      if (!_includeComplete) _includeIncomplete = true;
    });

    triggerOnAction(_actions.toggleIncludeIncomplete, (_) {
      _includeIncomplete = !_includeIncomplete;
      // One of these should be true at any given time, or nothing will be displayed.
      if (!_includeIncomplete) _includeComplete = true;
    });

    triggerOnAction(_actions.toggleIncludePrivate, (_) {
      _includePrivate = !_includePrivate;
      // One of these should be true at any given time, or nothing will be displayed.
      if (!_includePrivate) _includePublic = true;
    });

    triggerOnAction(_actions.toggleIncludePublic, (_) {
      _includePublic = !_includePublic;
      // One of these should be true at any given time, or nothing will be displayed.
      if (!_includePublic) _includePrivate = true;
    });

    manageStreamSubscription(_sdk.todoCreated.listen((todo) {
      _todosMap[todo.id] = todo;
      trigger();
    }));

    manageStreamSubscription(_sdk.todoDeleted.listen((todo) {
      _todosMap.remove(todo.id);
      trigger();
    }));

    manageStreamSubscription(_sdk.todoUpdated.listen((todo) {
      _todosMap[todo.id] = todo;
      trigger();
    }));

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

  _editTodo(Todo todo) {
    _modalManager.show((EditTodoModal()
      ..actions = _actions
      ..todo = todo)());
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
