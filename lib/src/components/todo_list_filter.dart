library todo_example.src.module.components.todo_filter;

import 'package:react/react.dart' as react;
import 'package:web_skin_dart/ui_core.dart';
import 'package:web_skin_dart/ui_components.dart';

import 'package:todo_example/src/actions.dart' show TodoActions;

var TodoListFilter = react.registerComponent(() => new _TodoListFilter());

class _TodoListFilter extends react.Component {
  TodoActions get actions => props['actions'];
  bool get includeComplete => props['includeComplete'];
  bool get includeIncomplete => props['includeIncomplete'];
  bool get includePrivate => props['includePrivate'];
  bool get includePublic => props['includePublic'];

  render() {
    return (Dom.div()..className = 'todo-list-filter')((ToggleInputGroup()
      ..groupLabel = 'Todo List Filters'
      ..hideGroupLabel = true)([
      (CheckboxInput()
        ..defaultChecked = includePrivate
        ..key = 'your-todos'
        ..label = 'Your Todos'
        ..onChange = (_) => actions.toggleIncludePrivate())(),
      (CheckboxInput()
        ..defaultChecked = includePublic
        ..key = 'public-todos'
        ..label = 'Public Todos'
        ..onChange = (_) => actions.toggleIncludePublic())(),
      (CheckboxInput()
        ..defaultChecked = includeIncomplete
        ..key = 'unfinished-todos'
        ..label = 'Unfinished Todos'
        ..onChange = (_) => actions.toggleIncludeIncomplete())(),
      (CheckboxInput()
        ..defaultChecked = includeComplete
        ..key = 'finished-todos'
        ..label = 'Finished Todos'
        ..onChange = (_) => actions.toggleIncludeComplete())(),
    ]));
  }
}
