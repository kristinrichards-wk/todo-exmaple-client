library todo_client.src.module.components.local_shell;

import 'package:web_skin_dart/ui_core.dart';
import 'package:web_skin_dart/ui_components.dart';

@Factory()
UiFactory<TodoLocalShellProps> TodoLocalShell;

@Props()
class TodoLocalShellProps extends UiProps {}

@Component()
class TodoLocalShellComponent extends UiComponent<TodoLocalShellProps> {
  @override
  render() {
    return (GridFrame()..addTestId('todoLocalShell.gridFrame'))(
      (VBlock()..addTestId('todoLocalShell.vBlock'))(
        (BlockContent()
          ..className = 'login-prompt'
          ..shrink = true
          ..addTestId('todoLocalShell.blockContent'))(
          'Want to save and share your todos? ',
          (Dom.a()
            ..href = '/login'
            ..addTestId('todoLocalShell.login'))('Sign in now.'),
        ),
        (Block()..addTestId('todoLocalShell.block'))(props.children),
      ),
    );
  }
}
