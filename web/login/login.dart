import 'dart:html';

import 'package:w_session/api.dart';

main() async {
  Uri sessionHost = Uri.parse('https://wk-dev.wdesk.org');
  SessionApi api = new SessionApi(sessionHost: sessionHost);
  AuthenticationStatus status = await api.getAuthenticationStatus();
  if (status.loggedIn) {
    window.location.pathname = '/';
  } else {
    api.redirectToLoginPage();
  }
}
