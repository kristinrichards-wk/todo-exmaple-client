library todo_example.src.module.components.todo_list_item;

import 'package:react/react.dart' as react;
import 'package:todo_example/service.dart' show Todo;
import 'package:web_skin_dart/ui_components.dart';

import 'package:todo_example/src/module/actions.dart' show TodoActions;

var TodoListItem = react.registerComponent(() => new _TodoListItem());

class _TodoListItem extends react.Component {
  TodoActions get actions => props['actions'];
  Todo get todo => props['todo'];

  render() {
    return (ListGroupItem()
      ..className = todo.isCompleted ? 'todo todo-complete' : 'todo todo-incomplete'
      ..href = '#'
      ..key = todo.id
    )([
      (Icon()
        ..glyph = IconGlyph.CHECKMARK
        ..onClick = _toggleCompletion
      )(),
      todo.description
    ]);
  }

  _toggleCompletion(e) {
    e.preventDefault();
    e.stopPropagation();

    actions.updateTodo(todo.change(isCompleted: !todo.isCompleted));
  }
}
