library todo_example.src.module.components.todo_list;

import 'package:react/react.dart' as react;
import 'package:todo_example/service.dart' show Todo;
import 'package:web_skin_dart/ui_components.dart';

import 'package:todo_example/src/module/actions.dart' show TodoActions;
import 'package:todo_example/src/module/components/todo_list_item.dart'
    show TodoListItem;

var TodoList = react.registerComponent(() => new _TodoList());

class _TodoList extends react.Component {
  TodoActions get actions => props['actions'];

  /// Sorted list of to-do items.
  List<Todo> get todos => props['todos'] != null ? props['todos'] : [];

  render() {
    print(todos.length);
    List todoItems = todos.map((todo) => TodoListItem({'actions': actions, 'todo': todo})).toList();
    print(todoItems);
    return (ListGroup()..isBordered = true)(todoItems);
  }
}
