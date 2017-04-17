import 'dart:html';

import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:web_skin_dart/test_util.dart';
import 'package:web_skin_dart/ui_components.dart';
import 'package:react/react_test_utils.dart' as react_test_utils;

import 'package:todo_client/src/components/create_todo_input.dart';

import '../mocks.dart';

main() {
  group('CreateTodoInput', () {
    test('renders a Form with correct props', () {
      var instance = render(CreateTodoInput()());
      var formProps = Form(getPropsByTestId(instance, 'createTodoInput.form'));

      expect(formProps.className, 'create-todo-input');
      expect(formProps.onSubmit, isNotNull);
    });

    test('renders a TextInput with correct props', () {
      var instance = render(CreateTodoInput()());
      var inputProps = TextInput(getPropsByTestId(instance, 'createTodoInput.input'));

      expect(inputProps.autoFocus, true);
      expect(inputProps.hideLabel, true);
      expect(inputProps.label, 'Create a Todo');
      expect(inputProps.onChange, isNotNull);
      expect(inputProps.placeholder, 'What do you need to do?');
      expect(inputProps.size, InputSize.LARGE);
      expect(inputProps.value, isEmpty);
    });

    test('renders a TextInput with correct props when state.newTodoDescription updates', () {
      var instance = render(CreateTodoInput()());
      CreateTodoInputComponent dartInstance = getDartComponent(instance);
      var inputProps = TextInput(getPropsByTestId(instance, 'createTodoInput.input'));

      expect(inputProps.value, isEmpty);

      dartInstance.setState(dartInstance.newState()..newTodoDescription = 'New Value');

      inputProps = TextInput(getPropsByTestId(instance, 'createTodoInput.input'));

      expect(inputProps.value, 'New Value');
    });

    group('updates state correctly on change', () {
      test('on change of the input', () {
        var instance = render(CreateTodoInput()());
        CreateTodoInputComponent dartInstance = getDartComponent(instance);
        var inputNode = queryByTestId(instance, 'createTodoInput.input');

        expect(dartInstance.state.newTodoDescription, isEmpty);

        change(inputNode, {'target': new TextInputElement()..value = 'New Value'});

        expect(dartInstance.state.newTodoDescription, 'New Value');
      });

      test('on submit of the form', () {
        var actions = new MockTodoActions();
        var instance = render((CreateTodoInput()
          ..actions = actions
        )());
        CreateTodoInputComponent dartInstance = getDartComponent(instance);
        var node = findDomNode(instance);

        expect(dartInstance.state.newTodoDescription, isEmpty);

        dartInstance.setState(dartInstance.newState()..newTodoDescription = 'New Value');

        expect(dartInstance.state.newTodoDescription, 'New Value');

        react_test_utils.Simulate.submit(node);

        verify(actions.createTodo(any)).called(1);
        expect(dartInstance.state.newTodoDescription, '');
      });
    });

    test('calls props.actions.createTodo on submit of the form', () {
      var preventDefaultCalled = false;
      var actions = new MockTodoActions();
      var instance = render((CreateTodoInput()
        ..actions = actions
      )());
      var node = findDomNode(instance);

      react_test_utils.Simulate.submit(node, {'preventDefault': () { preventDefaultCalled = true; }});

      expect(preventDefaultCalled, isTrue);
      verify(actions.createTodo(any)).called(1);
    });
  });
}
