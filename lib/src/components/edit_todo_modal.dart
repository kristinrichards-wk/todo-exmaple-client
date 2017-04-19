library todo_client.src.module.components.edit_todo_modal;

import 'package:todo_sdk/todo_sdk.dart' show Todo;
import 'package:react/react.dart' as react;
import 'package:web_skin_dart/ui_components.dart';
import 'package:web_skin_dart/ui_core.dart';

import 'package:todo_client/src/actions.dart';

@Factory()
UiFactory<EditTodoModalProps> EditTodoModal;

@Props()
class EditTodoModalProps extends ModalProps {
  TodoActions actions;
  Todo todo;
}

@Component(subtypeOf: ModalComponent)
class EditTodoModalComponent extends UiComponent<EditTodoModalProps> {
  TextInputComponent _titleInputRef;
  TextInputComponent _notesInputRef;

  @override
  render() {
    return (Modal()
      ..addProps(copyUnconsumedProps())
      ..header = 'Edit Todo')(
      (Form()..onSubmit = _save)(
        DialogBody()(
          (TextInput()
            ..label = 'Title'
            ..defaultValue = props.todo.description
            ..ref = (ref) {
              _titleInputRef = ref;
            })(),
          (TextInput()
            ..isMultiline = true
            ..placeholder = 'Notes'
            ..rows = 3
            ..defaultValue = props.todo.notes
            ..ref = (ref) {
              _notesInputRef = ref;
            })(),
        ),
        DialogFooter()(
          (FormSubmitInput()
            ..skin = ButtonSkin.SUCCESS
            ..pullRight = true)('Save'),
        ),
      ),
    );
  }

  void _save(react.SyntheticFormEvent event) {
    var modifiedTodo = props.todo.change(
      description: _titleInputRef.getValue(),
      notes: _notesInputRef.getValue(),
    );

    props.actions.updateTodo(modifiedTodo);
    if (props.onRequestHide != null) props.onRequestHide(event);
  }
}
