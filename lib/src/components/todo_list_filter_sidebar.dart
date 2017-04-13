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
        ..active = props.store.includePrivate
        ..icon = IconGlyph.TWFR_FOLDER
        ..onSelect = ((_) => props.actions.toggleIncludePrivate())
        ..text = 'Your Todos')(),
      (WorkspacesMenuItem()
        ..active = props.store.includePublic
        ..icon = IconGlyph.TWFR_FOLDER_OPEN
        ..onSelect = ((_) => props.actions.toggleIncludePublic())
        ..text = 'Public Todos')(),
      (WorkspacesMenuItem()
        ..active = props.store.includeIncomplete
        ..icon = IconGlyph.TWFR_TASK_CHECK
        ..onSelect = ((_) => props.actions.toggleIncludeIncomplete())
        ..text = 'Unfinished Todos')(),
      (WorkspacesMenuItem()
        ..active = props.store.includeComplete
        ..icon = IconGlyph.TWFR_TASK_CREATE
        ..onSelect = ((_) => props.actions.toggleIncludeComplete())
        ..text = 'Finished Todos')(),
    );
  }
}
