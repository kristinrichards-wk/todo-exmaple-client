import 'package:truss/modal_manager.dart' show ModalManager;
import 'package:w_module/w_module.dart';

import 'package:todo_client/src/actions.dart' show TodoActions;
import 'package:todo_client/src/store.dart' show TodoStore;

import 'package:todo_client/src/components/app.dart' show TodoApp;
import 'package:todo_client/src/components/local_shell.dart' show TodoLocalShell;
import 'package:todo_client/src/components/todo_list_filter_sidebar.dart'
    show TodoListFilterSidebar;

class TodoComponents extends ModuleComponents {
  TodoActions _actions;
  ModalManager _modalManager;
  TodoStore _store;

  TodoComponents(TodoActions actions, TodoStore store, ModalManager modalManager)
      : _actions = actions,
        _store = store,
        _modalManager = modalManager;

  @override
  content({String currentUserId: '', bool withFilter: true}) => (TodoApp()
    ..actions = _actions
    ..store = _store
    ..currentUserId = currentUserId
    ..withFilter = withFilter)();

  localShell() => TodoLocalShell()(content());

  sidebar() => (TodoListFilterSidebar()
    ..actions = _actions
    ..store = _store)();
}
