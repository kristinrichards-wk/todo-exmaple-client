library todo_client.src.module.components.app;

import 'package:todo_sdk/todo_sdk.dart' show Todo;
import 'package:web_skin_dart/ui_components.dart';
import 'package:web_skin_dart/ui_core.dart';

import 'package:todo_client/src/actions.dart' show TodoActions;
import 'package:todo_client/src/components/todo_list.dart';
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
  TextInputComponent _createInputRef;

  @override
  getDefaultProps() => (newProps()
    ..currentUserId = ''
    ..withFilter = true);

  @override
  render() {
    return (VBlock()..className = 'todo-app')(
      (BlockContent()..shrink = true)(
        (Form()
          ..onSubmit = (_) {
            props.actions.createTodo(new Todo(description: _createInputRef.getValue()));
          })(
          (TextInput()
            ..ref = (ref) {
              _createInputRef = ref;
            }
            ..autoFocus = true
            ..hideLabel = true
            ..label = 'Create a Todo'
            ..placeholder = 'What do you need to do?'
            ..size = InputSize.LARGE)(),
        ),
      ),
      BlockContent()(
        (ListGroup()
          ..className = 'todo-list'
          ..isBordered = true
          ..size = ListGroupSize.LARGE)(
          props.store.todos.map((todo) {
            return (ListGroupItem()
              ..className = 'todo-list__item'
              ..key = todo.id)(todo.description);
          }),
        ),
      ),
    );
  }
}
