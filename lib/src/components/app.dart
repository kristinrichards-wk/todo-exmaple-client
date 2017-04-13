library todo_client.src.module.components.app;

import 'package:react/react_client.dart';
import 'package:web_skin_dart/ui_core.dart';
import 'package:web_skin_dart/ui_components.dart';

import 'package:todo_client/src/actions.dart' show TodoActions;
import 'package:todo_client/src/store.dart' show TodoStore;

import 'package:todo_client/src/components/fab_toolbar.dart';
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
    elements.add((BlockContent()
      ..key = 'create'
      ..shrink = true)(
      (CreateTodoInput()..actions = props.actions)(),
    ));

    // Filter
    if (props.withFilter) {
      elements.add((BlockContent()
        ..collapse = BlockCollapse.VERTICAL
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
      ..key = 'todos'
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
      _renderFab(),
    ));

    return (VBlock()..className = 'todo-app')(elements);
  }

  ReactElement _renderFabButton({
    String name,
    bool isActive,
    MouseEventCallback onClick,
    IconGlyph glyph,
  }) {
    return (OverlayTrigger()
      ..overlay = Tooltip()(name)
      ..placement = OverlayPlacement.TOP)(
      (Button()
        ..size = ButtonSize.LARGE
        ..noText = true
        ..isActive = isActive
        ..onClick = onClick)(
        (Icon()..glyph = glyph)(),
      ),
    );
  }

  ReactElement _renderFab() {
    return (FabToolbar()..buttonContent = (Icon()..glyph = IconGlyph.FILTER)())(
      _renderFabButton(
        name: 'Your Todos',
        isActive: props.store.includePrivate,
        onClick: (e) => props.actions.toggleIncludePrivate(),
        glyph: IconGlyph.FOLDER,
      ),
      _renderFabButton(
        name: 'Public Todos',
        isActive: props.store.includePublic,
        onClick: (e) => props.actions.toggleIncludePublic(),
        glyph: IconGlyph.FOLDER_OPEN,
      ),
      _renderFabButton(
        name: 'Unfinished Todos',
        isActive: props.store.includeIncomplete,
        onClick: (e) => props.actions.toggleIncludeIncomplete(),
        glyph: IconGlyph.CHECKMARK,
      ),
      _renderFabButton(
        name: 'Finished Todos',
        isActive: props.store.includeComplete,
        onClick: (e) => props.actions.toggleIncludeComplete(),
        glyph: IconGlyph.TASK_CREATE,
      ),
    );
  }
}
