library todo_example.src.module.components;

import 'package:truss/modal_manager.dart' show ModalManager;
import 'package:w_module/w_module.dart';

import 'package:todo_example/src/module/actions.dart' show TodoActions;
import 'package:todo_example/src/module/store.dart' show TodoStore;

import 'package:todo_example/src/module/components/app.dart'
    show TodoAppComponent;
import 'package:todo_example/src/module/components/local_shell.dart'
    show TodoLocalShell;
import 'package:todo_example/src/module/components/todo_list_filter_sidebar.dart'
    show TodoListFilterSidebar;

class TodoComponents extends ModuleComponents {
  TodoActions _actions;
  ModalManager _modalManager;
  TodoStore _store;

  TodoComponents(
      TodoActions actions, TodoStore store, ModalManager modalManager)
      : _actions = actions,
        _store = store,
        _modalManager = modalManager;

  content({bool withFilter: true}) => TodoAppComponent(
      {'actions': _actions, 'store': _store, 'withFilter': withFilter == true});

  localShell() => TodoLocalShell({}, content());

  sidebar() => TodoListFilterSidebar({'actions': _actions, 'store': _store});

//  modal() => new TodoAppInModal(_modalManager, _actions, _store);
}
