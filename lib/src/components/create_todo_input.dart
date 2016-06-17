library todo_client.src.module.components.create_todo_input;

import 'dart:html';

import 'package:todo_sdk/todo_sdk.dart' show Todo;
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
class CreateTodoInputComponent extends UiStatefulComponent<CreateTodoInputProps, CreateTodoInputState> {

  @override
  getInitialState() => (newState()
    ..newTodoDescription = ''
  );

  render() {
    return (Form()
      ..className = 'create-todo-input'
      ..onSubmit = _createTodo
    )(
      (TextInput()
        ..autoFocus = true
        ..hideLabel = true
        ..label = 'Create a Todo'
        ..onChange = _updateNewTodoDescription
        ..placeholder = 'What do you need to do?'
        ..size = InputSize.LARGE
        ..value = state.newTodoDescription
      )()
    );
  }

  _createTodo(e) {
    e.preventDefault();
    Todo toCreate = new Todo(description: state.newTodoDescription);
    props.actions.createTodo(toCreate);
    setState(newState()..newTodoDescription = '');
  }

  _updateNewTodoDescription(e) {
    setState(newState()..newTodoDescription = (e.target as TextInputElement).value);
  }
}
