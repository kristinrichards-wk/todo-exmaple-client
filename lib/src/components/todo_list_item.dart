import 'package:todo_sdk/todo_sdk.dart';
import 'package:web_skin_dart/ui_core.dart';
import 'package:web_skin_dart/ui_components.dart';

@Factory()
UiFactory<TodoListItemProps> TodoListItem;

@Props()
class TodoListItemProps extends UiProps {
}

@Component()
class TodoListItemComponent extends UiComponent<TodoListItemProps> {
  @override
  Map getDefaultProps() => (newProps());

  @override
  render() {
  }
}
