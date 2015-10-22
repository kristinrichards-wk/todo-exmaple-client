library todo_client.src.module;

import 'package:todo_sdk/todo_sdk.dart' show TodoSdk;
import 'package:truss/modal_manager.dart' show ModalManager;
import 'package:w_module/w_module.dart';

import 'package:todo_client/src/actions.dart';
import 'package:todo_client/src/components.dart';
import 'package:todo_client/src/components/edit_todo_modal.dart';
import 'package:todo_client/src/store.dart';

class TodoModule extends Module {
  TodoActions _actions;
  TodoComponents _components;
  ModalManager _modalManager;
  TodoSdk _sdk;
  TodoStore _store;

  TodoModule(TodoSdk sdk, {ModalManager modalManager})
      : _modalManager = modalManager,
        _sdk = sdk {
    if (_modalManager == null) {
      _modalManager = new ModalManager();
    }

    _actions = new TodoActions();
    _store = new TodoStore(_actions, _sdk);
    _components = new TodoComponents(_actions, _store, _modalManager);

    _actions.editTodo.listen((todo) {
      new EditTodoModal(todo, _actions, _modalManager).show();
    });
  }

  TodoComponents get components => _components;
}
