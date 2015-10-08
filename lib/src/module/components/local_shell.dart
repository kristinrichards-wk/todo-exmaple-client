library todo_example.src.module.components.local_shell;

import 'package:react/react.dart' as react;
import 'package:web_skin_dart/ui_core.dart';
import 'package:web_skin_dart/ui_components.dart';

var TodoLocalShell = react.registerComponent(() => new _TodoLocalShell());
class _TodoLocalShell extends react.Component {
  get application => props['children'];

  render() {
    return (GridFrame())(
      VBlock()([
        (Block()
          ..className = 'login-prompt'
          ..content = true
          ..isNested = true
          ..shrink = true
        )(Dom.p()([
          'Want to save and share your todos? ',
          (Dom.a()
            ..href = '/wdesk'
          )('Sign in now.')
        ])),
        (Block()
          ..align = BlockAlign.CENTER
          ..gutter = BlockGutter.ALL
          ..isNested = true
        )(application)
      ])
    );
  }
}