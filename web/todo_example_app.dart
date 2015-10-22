library todo_client.web.local_todo_example;

import 'dart:html';

import 'package:react/react.dart' as react;
import 'package:react/react_client.dart' show setClientConfiguration;
import 'package:todo_client/todo_client.dart' show TodoModule;
import 'package:todo_sdk/todo_sdk.dart';
import 'package:w_session/api.dart';

import 'package:truss/truss.dart' show WorkspacesShell;
import 'package:w_oauth2/w_oauth2.dart';

import 'settings.dart' as settings;

String _decodeResourceId(resourceId, strip) => window.atob(resourceId).replaceAll('$strip\x1f', '');

main() async {
  setClientConfiguration();
  var container = querySelector('#shell-container');

  SessionApi sessionApi = new SessionApi(sessionHost: settings.sessionHost);
  if ((await sessionApi.getAuthenticationStatus()).loggedIn) {
    // User is authenticated. Use the wdesk version.

    // Instantiate and initialize the workspaces shell. This also establishes a
    // a valid session against our session host.
    WorkspacesShell shell = new WorkspacesShell(sessionHost: settings.sessionHost);
    await shell.load();

    // Set up our OAuth2 configuration.
    String clientId = 'w_oauth2_example';
    Uri currentHost = Uri.parse('${window.location.protocol}//${window.location.host}');
    Uri redirectUri = currentHost.replace(path: '/oauth2_token_management/oauth2redirect');
    OAuth2 oauth2 = new OAuth2(clientId, redirectUri.toString(), [], shell.session);

    // Instantiate the authenticated & authorized to-do SDK.
    TodoSdk todoSdk = new WdeskTodoSdk(shell.session, oauth2, settings.messagingFrontendHost);

    // Inject the service into our to-do module.
    TodoModule todoModule = new TodoModule(todoSdk);

    // Grab the main to-do UI, but hide the filter since we'll be placing a
    // variation of the filter in the workspaces sidebar.
    String user = _decodeResourceId(shell.session.context.user.resourceId, 'WFUser');
    var mainContent = todoModule.components.content(currentUserID: user, withFilter: false);

    // Construct the entire application component to render using the shell's
    // content factory.
    var component = shell.components.content(
        // Main content area of the shell.
        content: mainContent,
        // Populate the workspaces sidebar with a variant of the to-do filter.
        menuContent: todoModule.components.sidebar(),
        // Hide the create menu.
        menuHeader: null);

    react.render(component, container);
  } else {
    // User is not authenticated. Use the local version.

    // Use an implementation of the to-do SDK that uses localStorage.
    TodoSdk todoSdk = new LocalTodoSdk();

    // Inject this service into the to-do module.
    TodoModule todoModule = new TodoModule(todoSdk);

    // Render the module's local UI variant.
    react.render(todoModule.components.localShell(), container);
  }
}
