library todo_client.src.module.components.todo_list_filter_sidebar;

import 'package:truss/truss.dart';
import 'package:web_skin_dart/ui_core.dart';
import 'package:web_skin_dart/ui_components.dart';

import 'package:todo_client/src/actions.dart' show TodoActions;
import 'package:todo_client/src/store.dart' show TodoStore;

@Factory()
UiFactory<TodoListFilterSidebarProps> TodoListFilterSidebar;

@Props()
class TodoListFilterSidebarProps extends FluxUiProps<TodoActions, TodoStore> {}

@Component()
class TodoListFilterSidebarComponent extends FluxUiComponent<TodoListFilterSidebarProps> {
  @override
  render() {
    return WorkspacesMenu()(
      (WorkspacesMenuItem()
        ..active = true
        ..icon = IconGlyph.TASK_CREATE
        ..text = 'Todo List')(),
    );
  }
}
