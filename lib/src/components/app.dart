library todo_client.src.module.components.app;

import 'package:web_skin_dart/ui_core.dart';
import 'package:web_skin_dart/ui_components.dart';

import 'package:todo_client/src/actions.dart' show TodoActions;
import 'package:todo_client/src/store.dart' show TodoStore;

import 'package:todo_client/src/components/create_todo_input.dart';
import 'package:todo_client/src/components/todo_list.dart';
import 'package:todo_client/src/components/todo_list_filter.dart';

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
    var elements = [];

    // Create To-do Input
    elements.add((Block()
      ..content = true
      ..isNested = true
      ..key = 'create'
      ..shrink = true)(
      (CreateTodoInput()..actions = props.actions)(),
    ));

    // Filter
    if (props.withFilter) {
      elements.add((Block()
        ..collapse = BlockCollapse.VERTICAL
        ..content = true
        ..isNested = true
        ..key = 'filter'
        ..shrink = true)(
        (TodoListFilter()
          ..actions = props.actions
          ..includeComplete = props.store.includeComplete
          ..includeIncomplete = props.store.includeIncomplete
          ..includePrivate = props.store.includePrivate
          ..includePublic = props.store.includePublic)(),
      ));
    }

    // To-do List
    elements.add((Block()
      ..gutter = BlockGutter.ALL
      ..isNested = true
      ..key = 'todos')(
      (TodoList()
        ..actions = props.actions
        ..activeTodo = props.store.activeTodo
        ..currentUserId = props.currentUserId
        ..todos = props.store.todos)(),
    ));

    return (Block()
      ..align = BlockAlign.CENTER
      ..size = 12)(
      (VBlock()
        ..className = 'todo-app'
        ..isNested = true
        ..size = 12
        ..shrink = true)(elements),
    );
  }
}
