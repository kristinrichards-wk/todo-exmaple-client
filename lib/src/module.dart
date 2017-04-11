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

  TodoModule(this._sdk, {ModalManager modalManager}) {
    _modalManager = modalManager ?? new ModalManager();

    _actions = new TodoActions();
    _store = new TodoStore(_actions, _sdk);
    _components = new TodoComponents(_actions, _store);

    _actions.editTodo.listen((todo) {
      _modalManager.show((EditTodoModal()
        ..actions = _actions
        ..originalTodo = todo
        ..modalManager = _modalManager)());
    });
  }

  TodoComponents get components => _components;
}
