import 'dart:html';

import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:todo_sdk/todo_sdk.dart';
import 'package:web_skin_dart/test_util.dart';
import 'package:web_skin_dart/ui_core.dart';
import 'package:web_skin_dart/ui_components.dart';
import 'package:react/react_test_utils.dart' as react_test_utils;

import 'package:todo_client/src/components/edit_todo_modal.dart';

import '../mocks.dart';

main() {
  group('EditTodoModal', () {
    test('subtypes ModalComponent', () {
      isValidElementOfType((EditTodoModal()..todo = new Todo(description: 'Title', notes: 'Notes'))(), ModalComponent);
    });

    test('renders a Modal with correct props', () {
      var instance = render((EditTodoModal()..todo = new Todo(description: 'Title', notes: 'Notes'))());
      var modalProps = Modal(getPropsByTestId(instance, 'editTodoModal.modal'));

      expect(modalProps.header, 'Edit Todo');
    });

    test('renders a Form with correct props', () {
      var instance = render((EditTodoModal()..todo = new Todo(description: 'Title', notes: 'Notes'))());
      var formProps = Form(getPropsByTestId(instance, 'editTodoModal.form'));

      expect(formProps.onSubmit, isNotNull);
    });

    test('renders a DialogBody', () {
      var instance = render((EditTodoModal()..todo = new Todo(description: 'Title', notes: 'Notes'))());

      expect(getByTestId(instance, 'editTodoModal.dialogBody'), isNotNull);
    });

    test('renders a TextInput for editing the title', () {
      var instance = render((EditTodoModal()..todo = new Todo(description: 'Title', notes: 'Notes'))());
      var inputProps = TextInput(getPropsByTestId(instance, 'editTodoModal.titleInput'));

      expect(inputProps.label, 'Title');
      expect(inputProps.defaultValue, 'Title');
    });

    test('renders a TextInput for editing the Notes', () {
      var instance = render((EditTodoModal()..todo = new Todo(description: 'Title', notes: 'Notes'))());
      var inputProps = TextInput(getPropsByTestId(instance, 'editTodoModal.notesInput'));

      expect(inputProps.defaultValue, 'Notes');
      expect(inputProps.isMultiline, isTrue);
      expect(inputProps.placeholder, 'Notes');
      expect(inputProps.rows, 3);
    });

    test('renders a DialogFooter', () {
      var instance = render((EditTodoModal()..todo = new Todo(description: 'Title', notes: 'Notes'))());

      expect(getByTestId(instance, 'editTodoModal.dialogFooter'), isNotNull);
    });

    test('renders a FormSubmitInput with the correct props', () {
      var instance = render((EditTodoModal()..todo = new Todo(description: 'Title', notes: 'Notes'))());
      var inputProps = FormSubmitInput()
        ..addProps(new Map.from(getPropsByTestId(instance, 'editTodoModal.submitButton')));

      expect(inputProps.skin, ButtonSkin.SUCCESS);
      expect(inputProps.pullRight, isTrue);
      expect(inputProps.children, ['Save']);
    });

    test('calls the correct callbacks on submit', () {
      var callbacks = [];
      var actions = new MockTodoActions();
      var instance = render((EditTodoModal()
        ..todo = new Todo(description: 'Title', notes: 'Notes')
        ..actions = actions
        ..onRequestHide = (_) {
          callbacks.add('onRequestHide');
        }
      )());
      var formNode = queryByTestId(instance, 'editTodoModal.form');

      verifyNever(actions.updateTodo(any));
      expect(callbacks, isEmpty);

      (queryByTestId(instance, 'editTodoModal.titleInput') as InputElement).value = 'Modified Title';
      (queryByTestId(instance, 'editTodoModal.notesInput') as TextAreaElement).value = 'Modified Notes';

      react_test_utils.Simulate.submit(formNode);

      verify(actions.updateTodo(any)).called(1);
      // expect(modifiedTodo.description, 'Modified Title');
      // expect(modifiedTodo.notes, 'Modified Notes');
      expect(callbacks, ['onRequestHide']);
    });
  });
}
