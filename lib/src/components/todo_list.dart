
import 'package:todo_sdk/todo_sdk.dart' show Todo;
import 'package:web_skin_dart/ui_components.dart';
import 'package:web_skin_dart/ui_core.dart';

import 'package:todo_client/src/actions.dart' show TodoActions;
import 'package:todo_client/src/components/todo_list_item.dart';

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
      return (EmptyView()..header = 'No todos to show')(
        'Create one or adjust the filters.',
      );
    }

    var todoItems = props.todos.map((todo) => (TodoListItem()
      ..todo = todo
      ..key = todo.id)());

    return (ListGroup()
      ..className = 'todo-list'
      ..isBordered = true
      ..size = ListGroupSize.LARGE)(
      todoItems,
    );
  }
}
