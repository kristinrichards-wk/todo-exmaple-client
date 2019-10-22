import 'dart:html';

import 'package:messaging_sdk/messaging_sdk.dart' show FrontendConfig, NatsMessagingClient;
import 'package:react/react_client.dart' show setClientConfiguration;
import 'package:react/react_dom.dart' as react_dom;
import 'package:todo_client/todo_client.dart' show TodoModule;
import 'package:todo_sdk/todo_sdk.dart';
import 'package:truss/truss.dart' show WorkspacesShell;
import 'package:w_session/w_session.dart';
// Added to enable React component debugging via $r in the Dartium dev tools.
// ignore: unused_import
import 'package:web_skin_dart/ui_core.dart' show $r;

main() async {
  setClientConfiguration();

  // Setup the session and load the shell (which handles starting the session).
  final session = new Session(sessionHost: Uri.parse('https://wk-dev.wdesk.org'));
  final shell = new WorkspacesShell(session: session);
  await shell.load();

  // Establish a messaging connection.
  final frontendConfig = new FrontendConfig('https://messaging.wk-dev.wdesk.org');
  final natsMessagingClient = new NatsMessagingClient(session, frontendConfig);
  await natsMessagingClient.open();

  // Instantiate the authenticated & authorized to-do SDK.
  final todoSdk = new MockTodoSdk();

  // Inject the service into our to-do module.
  final todoModule = new TodoModule(todoSdk);

  // Grab the main to-do UI, but hide the filter since we'll be placing a
  // variation of the filter in the workspaces sidebar.
  var mainContent = todoModule.components
      .content(currentUserId: session.context.userResourceId, withFilter: false);

  // Construct the entire application component to render using the shell's
  // content factory.
  var component = shell.components.content(
      // Main content area of the shell.
      content: mainContent,
      // Hide the create menu.
      menuHeader: null);

  final container = querySelector('#shell-container');
  react_dom.render(component, container);
}
