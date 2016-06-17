library todo_client.src.module.components.todo_list;

import 'package:todo_sdk/todo_sdk.dart' show Todo;
import 'package:web_skin_dart/ui_components.dart';
import 'package:web_skin_dart/ui_core.dart';

import 'package:todo_client/src/actions.dart' show TodoActions;
import 'package:todo_client/src/components/todo_list_item.dart' show TodoListItem;

@Factory()
UiFactory<TodoListProps> TodoList;

@Props()
class TodoListProps extends UiProps {
  List<Todo> todos;
  Todo activeTodo;
  TodoActions actions;
  String currentUserId;
}

@Component()
class TodoListComponent extends UiComponent<TodoListProps> {

  @override
  getDefaultProps() => (newProps()
    ..todos = []
    ..activeTodo = null
    ..currentUserId = ''
  );

  @override
  render() {
    if (props.todos.isEmpty) {
      return (Block()..className = 'todo-list')((Dom.p()
        ..className = 'todo-list-empty')('No todos to show. Create one or adjust the filters.'));
    } else {
      List todoItems = props.todos
        .map((todo) => (TodoListItem()
          ..actions = props.actions
          ..currentUserId = props.currentUserId
          ..isExpanded = props.activeTodo == todo
          ..key = todo.id
          ..todo = todo
        )())
        .toList();
      return (VBlock()..className = 'todo-list')(todoItems);
    }
  }
}
