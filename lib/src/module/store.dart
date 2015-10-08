library todo_example.src.module.store;

import 'package:todo_example/service.dart' show Todo, TodoService;
import 'package:w_flux/w_flux.dart';

import 'package:todo_example/src/module/actions.dart' show TodoActions;

class TodoStore extends Store {
  TodoActions _actions;
  TodoService _service;
  Map<String, Todo> _todosMap = {};

  TodoStore(TodoActions actions, TodoService service)
      : _actions = actions,
        _service = service {
    _actions.createTodo.listen(_createTodo);
    _actions.updateTodo.listen(_updateTodo);
    _initialize();
  }

  List<Todo> get todos => _todosMap.values;

  _createTodo(Todo todo) async {
    Todo created = await _service.createTodo(todo);
    _todosMap[created.id] = created;
    trigger();
  }

  _updateTodo(Todo todo) async {
    Todo updated = await _service.updateTodo(todo);
    _todosMap[updated.id] = updated;
    trigger();
  }

  _initialize() async {
    List results = await _service.queryTodos(
        includeComplete: true,
        includeIncomplete: true,
        includePrivate: true,
        includePublic: true);
    for (Todo todo in results) {
      _todosMap[todo.id] = todo;
    }

//    if (_todos.isEmpty) {
//      _todos = [new Todo(description: 'Test Todo')];
//    }

    trigger();
  }
}
