library todo_example.src.module.components.create_todo_input;

import 'dart:html';

import 'package:react/react.dart' as react;
import 'package:todo_example/service.dart' show Todo;
import 'package:web_skin_dart/ui_components.dart';

import 'package:todo_example/src/module/actions.dart' show TodoActions;

var CreateTodoInput = react.registerComponent(() => new _CreateTodoInput());

class _CreateTodoInput extends react.Component {
  TodoActions get actions => props['actions'];
  String get newTodoDescription => state['newTodoDescription'];

  getInitialState() => {'newTodoDescription': ''};

  render() {
    return react.form(
        {'className': 'create-todo-input', 'onSubmit': _createTodo},
        (TextInput()
          ..autoFocus = true
          ..hideLabel = true
          ..label = 'Create a Todo'
          ..onChange = _updateNewTodoDescription
          ..onSubmit
          ..placeholder = 'What do you need to do?'
          ..size = InputSize.LARGE
          ..value = newTodoDescription)());
  }

  _createTodo(e) {
    e.preventDefault();
    Todo toCreate = new Todo(description: newTodoDescription);
    actions.createTodo(toCreate);
    setState({'newTodoDescription': ''});
  }

  _updateNewTodoDescription(e) {
    setState({'newTodoDescription': (e.target as TextInputElement).value});
  }
}
