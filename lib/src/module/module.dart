library todo_example.src.module;

import 'package:todo_example/service.dart' show TodoService;
import 'package:truss/modal_manager.dart' show ModalManager;
import 'package:w_module/w_module.dart';

import 'package:todo_example/src/module/actions.dart';
import 'package:todo_example/src/module/components.dart';
import 'package:todo_example/src/module/store.dart';

class TodoModule extends Module {
  TodoActions _actions;
  TodoComponents _components;
  ModalManager _modalManager;
  TodoService _service;
  TodoStore _store;

  TodoModule(TodoService service, {ModalManager modalManager})
      : _modalManager = modalManager,
        _service = service {
    if (_modalManager == null) {
      _modalManager = new ModalManager();
    }

    _actions = new TodoActions();
    _store = new TodoStore(_actions, _service);
    _components = new TodoComponents(_actions, _store, _modalManager);

    // Hook up modals
//    _actions.showClearModal.listen((_) {
//      new ClearTodosModal(_modalManager, _actions).show();
//    });
//    _actions.showHelpModal.listen((_) {
//      new HelpModal(_modalManager).show();
//    });
  }

  TodoComponents get components => _components;
}
