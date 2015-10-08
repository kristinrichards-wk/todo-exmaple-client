library todo_example.web.local_todo_example;

import 'dart:html';

import 'package:react/react.dart' as react;
import 'package:react/react_client.dart' show setClientConfiguration;
import 'package:todo_example/module.dart';
import 'package:todo_example/service.dart';

main() {
  TodoService todoService = new LocalTodoService();
  TodoModule todoModule = new TodoModule(todoService);

  var container = querySelector('#todo-example-container');
  setClientConfiguration();
  react.render(todoModule.components.localShell(), container);
}
