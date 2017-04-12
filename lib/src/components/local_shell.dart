library todo_client.src.module.components.local_shell;

import 'package:web_skin_dart/ui_core.dart';
import 'package:web_skin_dart/ui_components.dart';

@Factory()
UiFactory<TodoLocalShellProps> TodoLocalShell;

@Props()
class TodoLocalShellProps extends UiProps {}

@Component()
class TodoLocalShellComponent extends UiComponent<TodoLocalShellProps> {
  render() {
    return GridFrame()(
      VBlock()(
        (BlockContent()
          ..className = 'login-prompt'
          ..shrink = true)(
          'Want to save and share your todos? ',
          (Dom.a()..href = '/login')('Sign in now.'),
        ),
        Block()(props.children),
      ),
    );
  }
}
