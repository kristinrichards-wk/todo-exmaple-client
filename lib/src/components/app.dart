library todo_client.src.module.components.app;

import 'package:web_skin_dart/ui_components.dart';
import 'package:web_skin_dart/ui_core.dart';

import 'package:todo_client/src/actions.dart' show TodoActions;
import 'package:todo_client/src/components/create_todo_input.dart';
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
  @override
  getDefaultProps() => (newProps()
    ..currentUserId = ''
    ..withFilter = true);

  @override
  render() {
    return (VBlock()..className = 'todo-app')(
      (BlockContent()..shrink = true)(
        (CreateTodoInput()..actions = props.actions)(),
      ),
      (Block()
        // Add a top gutter and collapse the content's top padding
        // so that there's still space above when the content is scrolled.
        ..gutter = BlockGutter.TOP)(
        (BlockContent()..collapse = BlockCollapse.TOP)(
          (TodoList()
            ..actions = props.actions
            ..activeTodo = props.store.activeTodo
            ..currentUserId = props.currentUserId
            ..todos = props.store.todos)(),
        ),
      ),
    );
  }
}
