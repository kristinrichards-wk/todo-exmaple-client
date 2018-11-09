import 'dart:html';

import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:todo_sdk/todo_sdk.dart';
import 'package:web_skin_dart/test_util.dart';
import 'package:web_skin_dart/ui_core.dart';
import 'package:web_skin_dart/ui_components.dart';

import 'package:todo_client/src/components/todo_list_item.dart';

import '../mocks.dart';

main() {
  group('TodoListItem', () {
    group('renders a ListGroupItem with correct className', () {
      test('by default', () {
        var instance = render((TodoListItem()..todo = new Todo())());
        var listGroupItemProps =
            ListGroupItem(getPropsByTestId(instance, 'todoListItem.listGroupItem'));

        expect(listGroupItemProps.className, 'todo-list__item todo-list__item--incomplete');
      });

      test('when the todo is complete', () {
        var instance = render((TodoListItem()..todo = new Todo(isCompleted: true))());
        var listGroupItemProps =
            ListGroupItem(getPropsByTestId(instance, 'todoListItem.listGroupItem'));

        expect(listGroupItemProps.className, 'todo-list__item todo-list__item--complete');
      });

      test('when it is expanded', () {
        var instance = render((TodoListItem()
          ..todo = new Todo()
          ..isExpanded = true
        )());
        var listGroupItemProps =
            ListGroupItem(getPropsByTestId(instance, 'todoListItem.listGroupItem'));

        expect(listGroupItemProps.className,
            'todo-list__item todo-list__item--incomplete todo-list__item--expanded');
      });
    });

    test('renders the header with correct props', () {
      var instance = render((TodoListItem()..todo = new Todo(description: 'Description'))());
      var headerNode = queryByTestId(instance, 'todoListItem.header');

      expect(headerNode, hasAttr('role', Role.button));
      expect(headerNode.text, 'Description');
    });

    group('renders a ButtonToolbar with correct props', () {
      test('by default', () {
        var instance = render((TodoListItem()..todo = new Todo())());
        var buttonToolbarProps =
            ButtonToolbar(getPropsByTestId(instance, 'todoListItem.buttonToolbar'));

        expect(buttonToolbarProps.className, 'todo-list__item__controls-toolbar');
        expect(ariaProps(buttonToolbarProps).hidden, isTrue);
      });

      test('when a state.isChildFocused is true', () {
        var instance = render((TodoListItem()..todo = new Todo())());
        TodoListItemComponent dartInstance = getDartComponent(instance);

        dartInstance.setState(dartInstance.newState()..isChildFocused = true);

        var buttonToolbarProps =
            ButtonToolbar(getPropsByTestId(instance, 'todoListItem.buttonToolbar'));

        expect(buttonToolbarProps.className, 'todo-list__item__controls-toolbar');
        expect(ariaProps(buttonToolbarProps).hidden, isFalse);
      });

      test('when a state.isHovered is true', () {
        var instance = render((TodoListItem()..todo = new Todo())());
        TodoListItemComponent dartInstance = getDartComponent(instance);

        dartInstance.setState(dartInstance.newState()..isHovered = true);

        var buttonToolbarProps =
            ButtonToolbar(getPropsByTestId(instance, 'todoListItem.buttonToolbar'));

        expect(buttonToolbarProps.className, 'todo-list__item__controls-toolbar');
        expect(ariaProps(buttonToolbarProps).hidden, isFalse);
      });
    });

    group('behaves correctly when', () {
      test('the user hovers the todo item by updating the state', () {
        var instance = render((TodoListItem()..todo = new Todo())());
        TodoListItemComponent dartInstance = getDartComponent(instance);
        var node = findDomNode(instance);

        expect(dartInstance.state.isHovered, isFalse);

        mouseEnter(node);

        expect(dartInstance.state.isHovered, isTrue);
      });

      test('the user mouses out of the todo item by updating the state', () {
        var instance = render((TodoListItem()..todo = new Todo())());
        TodoListItemComponent dartInstance = getDartComponent(instance);
        var node = findDomNode(instance);

        expect(dartInstance.state.isHovered, isFalse);

        mouseEnter(node);

        expect(dartInstance.state.isHovered, isTrue);

        mouseLeave(node);

        expect(dartInstance.state.isHovered, isFalse);
      });

      test('the user focuses something within the todo item by updating the state', () {
        var instance = render((TodoListItem()..todo = new Todo())());
        TodoListItemComponent dartInstance = getDartComponent(instance);
        var node = findDomNode(instance);

        expect(dartInstance.state.isChildFocused, isFalse);

        focus(node);

        expect(dartInstance.state.isChildFocused, isTrue);
      });

      group('the user blurs something within the todo item by updating the state', () {
        test('and the relatedTarget is within the TodoListItem', () {
          var instance = render((TodoListItem()..todo = new Todo())());
          TodoListItemComponent dartInstance = getDartComponent(instance);
          var node = findDomNode(instance);

          expect(dartInstance.state.isChildFocused, isFalse);

          focus(node);

          expect(dartInstance.state.isChildFocused, isTrue);

          blur(node, {'relatedTarget': queryByTestId(instance, 'todoListItem.editButton')});
        });

        test('and the related target is outside the TodoListItem', () {
          var instance = render((TodoListItem()..todo = new Todo())());
          TodoListItemComponent dartInstance = getDartComponent(instance);
          var node = findDomNode(instance);

          expect(dartInstance.state.isChildFocused, isFalse);

          focus(node);

          expect(dartInstance.state.isChildFocused, isTrue);

          blur(node, {'relatedTarget': document.body});

          expect(dartInstance.state.isChildFocused, isFalse);
        });
      });

      test('when the delete button is clicked', () {
        var actions = new MockTodoActions();
        var instance = render((TodoListItem()
          ..currentUserId = 'user1'
          ..todo = new Todo(userID: 'user1')
          ..actions = actions
        )());

        click(queryByTestId(instance, 'todoListItem.deleteButton'));

        verify(actions.deleteTodo(any)).called(1);
      });
    });
  });
}
