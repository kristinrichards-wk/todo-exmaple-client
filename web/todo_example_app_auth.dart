import 'dart:html';

import 'package:react/react_client.dart' show setClientConfiguration;
import 'package:react/react_dom.dart' as react_dom;
import 'package:todo_client/todo_client.dart' show TodoModule;
import 'package:todo_sdk/todo_sdk.dart';

import 'package:truss/truss.dart' show WorkspacesShell;
import 'package:w_oauth2/w_oauth2.dart';

main() async {
  setClientConfiguration();
  var container = querySelector('#shell-container');
  Uri sessionHost = Uri.parse('https://wk-dev.wdesk.org');
  Uri messagingFrontendHost = Uri.parse('http://localhost:8100');

  // Instantiate and initialize the workspaces shell. This also establishes
  // a valid session against our session host.
  WorkspacesShell shell = new WorkspacesShell(sessionHost: sessionHost);
  await shell.load();

  // Set up our OAuth2 configuration.
  String clientId = 'w_oauth2_example';
  Uri currentHost = Uri.parse('${window.location.protocol}//${window.location.host}');
  Uri redirectUri = currentHost.replace(path: '/oauth2_token_management/oauth2redirect');
  OAuth2 oauth2 = new OAuth2(clientId, redirectUri.toString(), [], shell.session);

  // Instantiate the authenticated & authorized to-do SDK.
  TodoSdk todoSdk = new WdeskTodoSdk(oauth2, messagingFrontendHost);

  // Inject the service into our to-do module.
  TodoModule todoModule = new TodoModule(todoSdk);

  // Grab the main to-do UI, but hide the filter since we'll be placing a
  // variation of the filter in the workspaces sidebar.
  var mainContent = todoModule.components.content(currentUserId: shell.session.context.user.resourceId, withFilter: false);

  // Construct the entire application component to render using the shell's
  // content factory.
  var component = shell.components.content(
  // Main content area of the shell.
    content: mainContent,
  // Populate the workspaces sidebar with a variant of the to-do filter.
    menuContent: todoModule.components.sidebar(),
  // Hide the create menu.
    menuHeader: null);

  react_dom.render(component, container);
}