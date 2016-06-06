import 'dart:html';

import 'package:react/react_client.dart' show setClientConfiguration;
import 'package:react/react_dom.dart' as react_dom;
import 'package:todo_client/todo_client.dart' show TodoModule;
import 'package:todo_sdk/todo_sdk.dart';

main() async {
  setClientConfiguration();
  var container = querySelector('#shell-container');

  // Use an implementation of the to-do SDK that uses localStorage.
  TodoSdk todoSdk = new LocalTodoSdk();

  // Inject this service into the to-do module.
  TodoModule todoModule = new TodoModule(todoSdk);

  // Render the module's local UI variant.
  react_dom.render(todoModule.components.localShell(), container);
}