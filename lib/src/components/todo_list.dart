library todo_example.src.module.components.todo_list;

import 'package:react/react.dart' as react;
import 'package:todo_sdk/todo_sdk.dart' show Todo;
import 'package:web_skin_dart/ui_components.dart';
import 'package:web_skin_dart/ui_core.dart';

import 'package:todo_example/src/actions.dart' show TodoActions;
import 'package:todo_example/src/components/todo_list_item.dart' show TodoListItem;

var TodoList = react.registerComponent(() => new _TodoList());

class _TodoList extends react.Component {
  TodoActions get actions => props['actions'];

  Todo get activeTodo => props['activeTodo'];

  String get currentUserID => props['currentUserID'];

  /// Sorted list of to-do items.
  List<Todo> get todos => props['todos'] != null ? props['todos'] : [];

  render() {
    if (todos.isEmpty) {
      return (Block()..className = 'todo-list')((Dom.p()
        ..className = 'todo-list-empty')('No todos to show. Create one or adjust the filters.'));
    } else {
      List todoItems = todos
          .map((todo) => TodoListItem({
                'actions': actions,
                'currentUserID': currentUserID,
                'isExpanded': activeTodo == todo,
                'key': todo.id,
                'todo': todo
              }))
          .toList();
      return (VBlock()..className = 'todo-list')(todoItems);
    }
  }
}
