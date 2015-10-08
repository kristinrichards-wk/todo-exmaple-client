library todo_example.src.module.components.edit_todo_modal;

import 'dart:html';

import 'package:todo_example/service.dart' show Todo;
import 'package:truss/modal_manager.dart';
import 'package:web_skin_dart/ui_components.dart';
import 'package:web_skin_dart/ui_core.dart';

import 'package:todo_example/src/module/actions.dart';

class EditTodoModal extends ManagedModal {
  TodoActions _actions;
  Todo _todo;

  EditTodoModal(Todo todo, TodoActions actions, ModalManager modalManager)
      : super(modalManager),
        _todo = todo,
        _actions = actions;

  String get title => 'Edit Todo';

  renderModalContent() {
    var description = (TextInput()
      ..type = TextInputType.TEXT
      ..label = 'Title'
      ..value = _todo.description
      ..onChange = _updateTodoDescription)();

    var notes = (TextInput()
      ..isMultiline = true
      ..label = 'Notes'
      ..onChange = _updateTodoNotes
      ..placeholder = 'Notes'
      ..rows = 3
      ..value = _todo.notes)();

    var save = (FormSubmitInput()
      ..skin = ButtonSkin.SUCCESS
      ..onClick = _save
      ..pullRight = true
    )('Save');

    return [
      (Dom.div()
        ..className = 'modal-body'
      )(FormLayout()([description, notes])),
      (Dom.div()
        ..className = 'modal-footer'
      )(save)
    ];
  }

  _save(e) {
    e.preventDefault();
    e.stopPropagation();

    _actions.updateTodo(_todo);
    hide();
  }

  _updateTodoDescription(e) {
    var value = (e.target as TextInputElement).value;
    _todo = _todo.change(description: value);
    redraw();
  }

  _updateTodoNotes(e) {
    var value = (e.target as TextAreaElement).value;
    _todo = _todo.change(notes: value);
    redraw();
  }
}