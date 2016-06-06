library todo_client.src.module.components.edit_todo_modal;

import 'dart:html';

import 'package:todo_sdk/todo_sdk.dart' show Todo;
import 'package:truss/modal_manager.dart';
import 'package:web_skin_dart/ui_components.dart';
import 'package:web_skin_dart/ui_core.dart';

import 'package:todo_client/src/actions.dart';

@Factory()
UiFactory<EditTodoModalProps> EditTodoModal;

@Props()
class EditTodoModalProps extends ModalProps {
  TodoActions actions;
  ModalManager modalManager;
  Todo originalTodo;
}

@State()
class EditTodoModalState extends UiState {
  String description;
  String notes;
}

@Component(subtypeOf: ModalComponent)
class EditTodoModalComponent extends UiStatefulComponent<EditTodoModalProps, EditTodoModalState> {

  @override
  getInitialState() => (newState()
    ..description = props.originalTodo.description
    ..notes = props.originalTodo.notes
  );

  @override
  render() {
    return (Modal()
      ..addProps(copyUnconsumedProps())
      ..title = 'Edit Todo'
    )((Dom.div()
        ..className = 'modal-body'
      )((FormLayout()
        )((TextInput()
            ..type = TextInputType.TEXT
            ..label = 'Title'
            ..onChange = _updateTodoDescription
            ..value = state.description
          )(),
          (TextInput()
            ..isMultiline = true
            ..label = 'Notes'
            ..onChange = _updateTodoNotes
            ..placeholder = 'Notes'
            ..rows = 3
            ..value = state.notes
          )()
        )
      ),
      (Dom.div()
        ..className = 'modal-footer'
      )((FormSubmitInput()
        ..skin = ButtonSkin.SUCCESS
        ..onClick = _save
        ..pullRight = true
        )('Save')
      )
    );
  }

  _save(e) {
    e.preventDefault();
    e.stopPropagation();
    props.actions.updateTodo(props.originalTodo);
    props.onRequestHide(e);
  }

  _updateTodoDescription(e) {
    String value = (e.target as TextInputElement).value;
    setState(newState()
      ..description = value
    );
    props.originalTodo = props.originalTodo.change(description: value);
  }

  _updateTodoNotes(e) {
    String value = (e.target as TextAreaElement).value;
    setState(newState()
     ..notes = value
    );
    props.originalTodo = props.originalTodo.change(notes: value);
  }
}