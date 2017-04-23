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
}

@State()
class CreateTodoInputState extends UiState {
}

@Component()
class CreateTodoInputComponent
    extends UiStatefulComponent<CreateTodoInputProps, CreateTodoInputState> {
  @override
  Map getInitialState() => (newState());

  @override
  render() {
  }
}
