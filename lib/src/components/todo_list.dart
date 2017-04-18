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
    ..todos = const []
    ..currentUserId = '');

  @override
  render() {
    if (props.todos.isEmpty) {
      return (EmptyView()
        ..header = 'No todos to show'
        ..addTestId('todoList.emptyView'))(
        'Create one or adjust the filters.',
      );
    }

    var todoItems = props.todos.map((todo) => (TodoListItem()
      ..actions = props.actions
      ..currentUserId = props.currentUserId
      ..isExpanded = props.activeTodo == todo
      ..key = todo.id
      ..todo = todo
      ..addTestId('todoList.todoListItem.${todo.id}'))());

    return (ListGroup()
      ..className = 'todo-list'
      ..isBordered = true
      ..size = ListGroupSize.LARGE
      ..addTestId('todoList.listGroup'))(
      todoItems,
    );
  }
}
