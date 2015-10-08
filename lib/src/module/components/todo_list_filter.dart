library todo_example.src.module.components.todo_filter;

import 'package:react/react.dart' as react;
import 'package:web_skin_dart/ui_components.dart';

import 'package:todo_example/src/module/actions.dart' show TodoActions;

var TodoListFilter = react.registerComponent(() => new _TodoListFilter());

class _TodoListFilter extends react.Component {
  TodoActions get actions => props['actions'];
  bool get includeComplete => props['includeComplete'];
  bool get includeIncomplete => props['includeIncomplete'];
  bool get includePrivate => props['includePrivate'];
  bool get includePublic => props['includePublic'];

  render() {
    return react.div({
      'className': 'todo-list-filter'
    }, [
      (ToggleInputGroup()([
        (CheckboxInput()
          ..checked = includePrivate
          ..label = 'Your Todos'
          ..onChange = (_) => actions.toggleIncludePrivate())(),
        (CheckboxInput()
          ..checked = includePublic
          ..label = 'Public Todos'
          ..onChange = (_) => actions.toggleIncludePublic())(),
        (CheckboxInput()
          ..checked = includeIncomplete
          ..label = 'Unfinished Todos'
          ..onChange = (_) => actions.toggleIncludeIncomplete())(),
        (CheckboxInput()
          ..checked = includeComplete
          ..label = 'Finished Todos'
          ..onChange = (_) => actions.toggleIncludeComplete())(),
      ]))
    ]);
  }
}
