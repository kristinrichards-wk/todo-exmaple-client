import 'dart:html';

import 'package:todo_sdk/todo_sdk.dart' show Todo;
import 'package:react/react.dart' as react;
import 'package:web_skin_dart/ui_components.dart';
import 'package:web_skin_dart/ui_core.dart';

import 'package:todo_client/src/actions.dart' show TodoActions;

@Factory()
UiFactory<CreateTodoInputProps> CreateTodoInput;

@Props()
class CreateTodoInputProps extends UiProps {
  TodoActions actions;
}

@State()
class CreateTodoInputState extends UiState {
  String newTodoDescription;
}

@Component()
class CreateTodoInputComponent
    extends UiStatefulComponent<CreateTodoInputProps, CreateTodoInputState> {
  @override
  Map getInitialState() => (newState()..newTodoDescription = '');

  @override
  render() {
    return (Form()
      ..onSubmit = _createTodo
      ..addTestId('createTodoInput.form')
    )(
      (TextInput()
        ..autoFocus = true
        ..hideLabel = true
        ..label = 'Create a Todo'
        ..placeholder = 'What do you need to do?'
        ..size = InputSize.LARGE
        ..onChange = _updateNewTodoDescription
        ..value = state.newTodoDescription
        ..addTestId('createTodoInput.input')
      )(),
    );
  }

  void _createTodo(_) {
    props.actions.createTodo(new Todo(description: state.newTodoDescription));
    setState(newState()..newTodoDescription = '');
  }

  void _updateNewTodoDescription(react.SyntheticFormEvent event) {
    TextInputElement input = event.target;
    setState(newState()..newTodoDescription = input.value);
  }
}
