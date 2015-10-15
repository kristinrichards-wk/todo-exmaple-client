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
        'active': store.includePrivate,
        'icon': 'twfr-folder',
        'key': 'your-todos',
        'onSelect': (_) => actions.toggleIncludePrivate(),
        'text': 'Your Todos',
      }),
      WorkspacesMenuItem({
        'active': store.includePublic,
        'icon': 'twfr-folder-open',
        'key': 'public-todos',
        'onSelect': (_) => actions.toggleIncludePublic(),
        'text': 'Public Todos',
      }),
      WorkspacesMenuItem({
        'active': store.includeIncomplete,
        'icon': 'twfr-task-check',
        'key': 'unfinished-todos',
        'onSelect': (_) => actions.toggleIncludeIncomplete(),
        'text': 'Unfinished Todos',
      }),
      WorkspacesMenuItem({
        'active': store.includeComplete,
        'icon': 'twfr-task-create',
        'key': 'finished-todos',
        'onSelect': (_) => actions.toggleIncludeComplete(),
        'text': 'Finished Todos',
      }),
    ]);
  }
}
