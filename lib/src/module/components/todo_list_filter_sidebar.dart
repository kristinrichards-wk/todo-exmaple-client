library todo_example.src.module.components.todo_list_filter_sidebar;

import 'package:react/react.dart' as react;
import 'package:truss/truss.dart';
import 'package:w_flux/w_flux.dart';

import 'package:todo_example/src/module/actions.dart' show TodoActions;
import 'package:todo_example/src/module/store.dart' show TodoStore;

var TodoListFilterSidebar =
    react.registerComponent(() => new _TodoListFilterSidebar());

class _TodoListFilterSidebar extends FluxComponent<TodoActions, TodoStore> {
  TodoActions get actions => props['actions'];

  render() {
    return WorkspacesMenu({}, [
      WorkspacesMenuItem({
        'icon': 'twfr-folder',
        'text': 'Your Todos',
        'onSelect': (_) => actions.toggleIncludePrivate(),
        'active': store.includePrivate
      }),
      WorkspacesMenuItem({
        'icon': 'twfr-folder-open',
        'text': 'Public Todos',
        'onSelect': (_) => actions.toggleIncludePublic(),
        'active': store.includePublic
      }),
      WorkspacesMenuItem({
        'icon': 'twfr-task-check',
        'text': 'Unfinished Todos',
        'onSelect': (_) => actions.toggleIncludeIncomplete(),
        'active': store.includeIncomplete
      }),
      WorkspacesMenuItem({
        'icon': 'twfr-task-create',
        'text': 'Finished Todos',
        'onSelect': (_) => actions.toggleIncludeComplete(),
        'active': store.includeComplete
      }),
    ]);
  }
}
