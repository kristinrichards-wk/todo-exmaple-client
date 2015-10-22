library todo_client.src.module.components.local_shell;

import 'package:react/react.dart' as react;
import 'package:web_skin_dart/ui_core.dart';
import 'package:web_skin_dart/ui_components.dart';

var TodoLocalShell = react.registerComponent(() => new _TodoLocalShell());

class _TodoLocalShell extends react.Component {
  get application => props['children'];

  render() {
    return (GridFrame())(VBlock()([
      (Block()
        ..className = 'login-prompt'
        ..content = true
        ..isNested = true
        ..key = 'login-prompt'
        ..shrink = true)(Dom.p()([
        (Dom.span()..key = 'text')('Want to save and share your todos? '),
        (Dom.a()
          ..href = '/login'
          ..key = 'login-link')('Sign in now.')
      ])),
      (Block()
        ..gutter = BlockGutter.ALL
        ..isNested = true
        ..key = 'app')(application)
    ]));
  }
}
