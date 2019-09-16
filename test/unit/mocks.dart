import 'package:mockito/mockito.dart';

import 'package:todo_client/src/actions.dart' show TodoActions;
import 'package:todo_client/src/store.dart' show TodoStore;

class MockTodoActions extends Mock implements TodoActions {}

class MockTodoStore extends Mock implements TodoStore {}
