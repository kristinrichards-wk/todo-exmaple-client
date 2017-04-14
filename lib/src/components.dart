import 'package:w_module/w_module.dart';

import 'package:todo_client/src/actions.dart' show TodoActions;
import 'package:todo_client/src/store.dart' show TodoStore;

import 'package:todo_client/src/components/app.dart' show TodoApp;

class TodoComponents extends ModuleComponents {
  TodoActions _actions;
  TodoStore _store;

  TodoComponents(TodoActions actions, TodoStore store)
      : _actions = actions,
        _store = store;

  @override
  content({String currentUserId: '', bool withFilter: true}) => (TodoApp()
    ..actions = _actions
    ..store = _store
    ..currentUserId = currentUserId
    ..withFilter = withFilter)();
}
