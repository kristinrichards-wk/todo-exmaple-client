library todo_client.src.module.components.app;

import 'package:web_skin_dart/ui_core.dart';

import 'package:todo_client/src/actions.dart' show TodoActions;
import 'package:todo_client/src/store.dart' show TodoStore;

@Factory()
UiFactory<TodoAppProps> TodoApp;

@Props()
class TodoAppProps extends FluxUiProps<TodoActions, TodoStore> {
  String currentUserId;
  bool withFilter;
}

@Component()
class TodoAppComponent extends FluxUiComponent<TodoAppProps> {
  @override
  getDefaultProps() => (newProps()
    ..currentUserId = ''
    ..withFilter = true
  );

  @override
  render() {
    return (Dom.div()..className = 'todo-app')(
      'Hello world!',
    );
  }
}
