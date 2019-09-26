library todo_client.src.module.components.app;

import 'package:web_skin_dart/ui_components.dart';
import 'package:web_skin_dart/ui_core.dart';

import 'package:todo_sdk/todo_sdk.dart' show Todo;
import 'package:todo_client/src/components/todo_item.dart' show TodoItem;
import 'package:todo_client/src/actions.dart' show TodoActions;


@Factory()
UiFactory<TodoListProps> TodoList;

@Props()
class TodoListProps extends UiProps {
  List<Todo> todoItems;
  TodoActions actions;
}

@Component()
class TodoListComponent extends UiComponent<TodoListProps> {
    
  @override
  Map getDefaultProps() => (newProps()
    ..todoItems = const []
  );

  @override
  render() {
    var todos = props.todoItems.map((item) {
      return (TodoItem()
        ..actions = props.actions
        ..todoItem = item
        ..key = item.id
        )();
    });

    return (ListGroup()
      ..className = 'todo-list'
      ..isBordered = true
      ..size = ListGroupSize.LARGE
    )(todos);
  }
}