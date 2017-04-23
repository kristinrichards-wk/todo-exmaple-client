import 'package:todo_sdk/todo_sdk.dart' show Todo;
import 'package:web_skin_dart/ui_components.dart';
import 'package:web_skin_dart/ui_core.dart';

import 'package:todo_client/src/actions.dart' show TodoActions;

@Factory()
UiFactory<TodoListProps> TodoList;

@Props()
class TodoListProps extends UiProps {
}

@Component()
class TodoListComponent extends UiComponent<TodoListProps> {
  @override
  getDefaultProps() => (newProps());

  @override
  render() {
  }
}
