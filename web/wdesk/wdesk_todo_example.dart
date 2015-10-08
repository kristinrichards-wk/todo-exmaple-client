library todo_example.web.wdesk.wdesk_todo_example;

import 'dart:html';

import 'package:react/react.dart' as react;
import 'package:react/react_client.dart' show setClientConfiguration;
import 'package:todo_example/module.dart';
import 'package:todo_example/service.dart';
import 'package:truss/truss.dart' show WorkspacesShell;
import 'package:web_skin_dart/ui_components.dart';

main() async {
  setClientConfiguration();

  TodoService todoService = new WdeskTodoService();
  TodoModule todoModule = new TodoModule(todoService);

  Uri sessionHost = Uri.parse('https://wk-dev.wdesk.org');
  WorkspacesShell shell = new WorkspacesShell(sessionHost: sessionHost);
  await shell.load();

  var container = querySelector('#shell-container');
  var mainContent = (Panel()
      ..addProp('style', {'marginBottom': 0, 'width': '100%'})
  )(todoModule.components.content());
  var component = shell.components.content(content: mainContent);
  react.render(component, container);
}
