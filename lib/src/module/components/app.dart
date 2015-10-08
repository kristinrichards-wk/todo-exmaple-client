library todo_example.src.module.components.app;

import 'package:w_flux/w_flux.dart';
import 'package:react/react.dart' as react;
import 'package:web_skin_dart/ui_components.dart';

import 'package:todo_example/src/module/actions.dart' show TodoActions;
import 'package:todo_example/src/module/store.dart' show TodoStore;

import 'package:todo_example/src/module/components/create_todo_input.dart' show CreateTodoInput;
import 'package:todo_example/src/module/components/todo_list.dart' show TodoList;

var TodoAppComponent = react.registerComponent(() => new _TodoAppComponent());

class _TodoAppComponent extends FluxComponent<TodoActions, TodoStore> {
  render() {
    return ((VBlock()
      ..className = 'todo-app'
      ..isNested = true
      ..size = 8
      ..shrink = true
    )([
      (Block()
        ..content = true
        ..isNested = true
        ..shrink = true
      )(CreateTodoInput({'actions': actions})),
      (Block()
        ..content = true
        ..isNested = true
      )(TodoList({'actions': actions, 'todos': store.todos}))
    ]));
  }
}
