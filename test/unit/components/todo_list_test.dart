import 'package:test/test.dart';
import 'package:todo_sdk/todo_sdk.dart' show Todo;
import 'package:web_skin_dart/test_util.dart';
import 'package:web_skin_dart/ui_components.dart';

import 'package:todo_client/src/components/todo_list.dart';
import 'package:todo_client/src/components/todo_list_item.dart';
import 'package:todo_client/src/actions.dart' show TodoActions;

main() {
  group('TodoList', () {
    test('renders an EmptyView when props.todos is empty', () {
      var instance = render(TodoList()());
      var emptyViewProps = EmptyView(getPropsByTestId(instance, 'todoList.emptyView'));

      expect(emptyViewProps.header, 'No todos to show. Create one or adjust the filters.');
    });

    test('renders a ListGroup with correct props', () {
      var instance = render((TodoList()
        ..todos = [new Todo()]
      )());
      var listGroupProps = ListGroup(getPropsByTestId(instance, 'todoList.listGroup'));


      expect(listGroupProps.className, 'todo-list');
      expect(listGroupProps.isBordered, isTrue);
      expect(listGroupProps.size, ListGroupSize.LARGE);
    });

    test('renders TodoListItems with correct props', () {
      var actions = new TodoActions();
      var activeTodo = new Todo(id: 'active_todo');
      var nonActiveTodo = new Todo(id: 'non_active_todo');
      var instance = render((TodoList()
        ..actions = actions
        ..currentUserId = 'user_id'
        ..activeTodo = activeTodo
        ..todos = [activeTodo, nonActiveTodo]
      )());
      var activeTodoProps = TodoListItem(getPropsByTestId(instance, 'todoList.todoListItem.active_todo'));
      var nonActiveTodoProps = TodoListItem(getPropsByTestId(instance, 'todoList.todoListItem.non_active_todo'));


      expect(activeTodoProps.actions, actions);
      expect(activeTodoProps.currentUserId, 'user_id');
      expect(activeTodoProps.isExpanded, isTrue);
      expect(activeTodoProps.todo, activeTodo);

      expect(nonActiveTodoProps.actions, actions);
      expect(nonActiveTodoProps.currentUserId, 'user_id');
      expect(nonActiveTodoProps.isExpanded, isFalse);
      expect(nonActiveTodoProps.todo, nonActiveTodo);
    });
  });
}
