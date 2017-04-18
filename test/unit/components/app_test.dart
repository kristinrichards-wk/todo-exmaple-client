import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:todo_sdk/todo_sdk.dart';
import 'package:web_skin_dart/test_util.dart';
import 'package:web_skin_dart/ui_components.dart';

import 'package:todo_client/src/components/app.dart';
import 'package:todo_client/src/components/create_todo_input.dart';
import 'package:todo_client/src/components/todo_list.dart';
import 'package:todo_client/src/components/todo_list_fab.dart';

import '../mocks.dart';

main() {
  group('TodoApp', () {
    var instance;
    MockTodoActions actions;
    MockTodoStore store;
    final activeTodo = new Todo(id: 'active_todo');
    final todos = [activeTodo, new Todo(id: 'non_active_todo')];

    setUp(() {
      actions = new MockTodoActions();
      store = new MockTodoStore();

      when(store.activeTodo).thenReturn(activeTodo);
      when(store.todos).thenReturn(todos);
      when(store.includePrivate).thenReturn(true);
      when(store.includePublic).thenReturn(true);
      when(store.includeIncomplete).thenReturn(true);
      when(store.includeComplete).thenReturn(true);

      instance = render((TodoApp()
        ..actions = actions
        ..store = store
        ..currentUserId = 'User Id'
      )());
    });

    test('renders a VBlock with correct props', () {
      var mainContentProps = VBlock(getPropsByTestId(instance, 'app.mainContent'));

      expect(mainContentProps.className, 'todo-app');
    });

    test('renders a CreateTodoInput correctly', () {
      var createTodoInputWrapperProps = BlockContent(getPropsByTestId(instance, 'app.createTodoInputWrapper'));
      var createTodoInputProps = CreateTodoInput(getPropsByTestId(instance, 'app.createTodoInput'));

      expect(createTodoInputWrapperProps.shrink, isTrue);
      expect(createTodoInputProps.actions, actions);
    });

    test('renders a TodoList and TodoListFab correctly', () {
      var listAndFabWrapperProps = Block(getPropsByTestId(instance, 'app.listAndFabWrapper'));
      var listWrapperProps = BlockContent(getPropsByTestId(instance, 'app.listWrapper'));
      var todoListProps = TodoList(getPropsByTestId(instance, 'app.todoList'));
      var todoListFabProps = TodoListFab(getPropsByTestId(instance, 'app.todoListFab'));

      expect(listAndFabWrapperProps.gutter, BlockGutter.TOP);

      expect(listWrapperProps.collapse, BlockCollapse.TOP);

      expect(todoListProps.actions, actions);
      expect(todoListProps.activeTodo, activeTodo);
      expect(todoListProps.currentUserId, 'User Id');
      expect(todoListProps.todos, todos);

      expect(todoListFabProps.actions, actions);
      expect(todoListFabProps.store, store);
    });
  });
}
