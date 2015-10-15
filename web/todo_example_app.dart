library todo_example.web.local_todo_example;

import 'dart:html';

import 'package:react/react.dart' as react;
import 'package:react/react_client.dart' show setClientConfiguration;
import 'package:todo_example/module.dart';
import 'package:todo_example/service.dart';
import 'package:w_session/api.dart';

import 'package:messaging_sdk/messaging_sdk.dart';
import 'package:truss/truss.dart' show WorkspacesShell;
import 'package:w_oauth2/w_oauth2.dart';
import 'package:w_service/w_service.dart';

main() async {
  setClientConfiguration();
  var container = querySelector('#shell-container');

  Uri sessionHost = Uri.parse('https://wk-dev.wdesk.org');
  SessionApi sessionApi = new SessionApi(sessionHost: sessionHost);
  if ((await sessionApi.getAuthenticationStatus()).loggedIn) {
    // User is authenticated. Use the wdesk version.

    WorkspacesShell shell = new WorkspacesShell(sessionHost: sessionHost);
    await shell.load();

    String clientId = 'w_oauth2_example';
    String redirectUri =
        'http://localhost:8080/oauth2_token_management/oauth2redirect';
    List<String> scope = ['sox|r', 'sox|w'];

    OAuth2 oauth2 = new OAuth2(clientId, redirectUri, scope, shell.session);
    await oauth2.start();

    String membershipResourceId =
        window.atob(shell.session.context.membership.resourceId);
    String membershipId = membershipResourceId.replaceAll('Membership\x1f', '');

    HttpProvider clientProvider = new HttpProvider()
      ..use(oauth2.httpInterceptor);
    Options options =
        new Options('http://localhost:8100', membershipId, clientProvider);
    Client client = new Client(options);
    await client.open();

    TodoService todoService =
        new WdeskTodoService(client, shell.session, oauth2);
    TodoModule todoModule = new TodoModule(todoService);

    var mainContent = todoModule.components.content(withFilter: false);
    var component = shell.components.content(
        content: mainContent,
        menuContent: todoModule.components.sidebar(),
        menuHeader: null);
    react.render(component, container);
  } else {
    // User is not authenticated. Use the local version.

    TodoService todoService = new LocalTodoService();
    TodoModule todoModule = new TodoModule(todoService);
    react.render(todoModule.components.localShell(), container);
  }
}
