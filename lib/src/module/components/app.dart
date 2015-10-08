library todo_example.src.module.components.app;

import 'package:w_flux/w_flux.dart';
import 'package:react/react.dart' as react;
import 'package:web_skin_dart/ui_core.dart';
import 'package:web_skin_dart/ui_components.dart';

import 'package:todo_example/src/module/actions.dart' show TodoActions;
import 'package:todo_example/src/module/store.dart' show TodoStore;

import 'package:todo_example/src/module/components/create_todo_input.dart'
    show CreateTodoInput;
import 'package:todo_example/src/module/components/todo_list.dart'
    show TodoList;
import 'package:todo_example/src/module/components/todo_list_filter.dart'
    show TodoListFilter;

var TodoAppComponent = react.registerComponent(() => new _TodoAppComponent());

class _TodoAppComponent extends FluxComponent<TodoActions, TodoStore> {
  bool get withFilter => props['withFilter'];

  render() {
    var elements = [];

    // Create To-do Input
    elements.add((Block()
      ..content = true
      ..isNested = true
      ..shrink = true)(CreateTodoInput({'actions': actions})));

    // Filter
    if (withFilter) {
      elements.add((Block()
        ..collapse = BlockCollapse.VERTICAL
        ..content = true
        ..isNested = true
        ..shrink = true)(TodoListFilter({
        'actions': actions,
        'includeComplete': store.includeComplete,
        'includeIncomplete': store.includeIncomplete,
        'includePrivate': store.includePrivate,
        'includePublic': store.includePublic
      })));
    }

    // To-do List
    elements.add((Block()
      ..gutter = BlockGutter.ALL
      ..isNested = true)(TodoList({
      'actions': actions,
      'activeTodo': store.activeTodo,
      'todos': store.todos
    })));

    return (Block()
      ..align = BlockAlign.CENTER
      ..size = 12
    )((VBlock()
      ..className = 'todo-app'
      ..isNested = true
      ..size = 12
      ..shrink = true)(elements));
  }
}
