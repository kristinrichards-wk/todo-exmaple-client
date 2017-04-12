library todo_client.src.module.components.todo_filter;

import 'package:web_skin_dart/ui_core.dart';
import 'package:web_skin_dart/ui_components.dart';

import 'package:todo_client/src/actions.dart' show TodoActions;

@Factory()
UiFactory<TodoListFilterProps> TodoListFilter;

@Props()
class TodoListFilterProps extends UiProps {
  TodoActions actions;
  bool includeComplete;
  bool includeIncomplete;
  bool includePrivate;
  bool includePublic;
}

@Component()
class TodoListFilterComponent extends UiComponent<TodoListFilterProps> {
  @override
  getDefaultProps() => (newProps()
    ..includeComplete = false
    ..includeIncomplete = false
    ..includePrivate = false
    ..includePublic = false);

  @override
  render() {
    return (Dom.div()..className = 'todo-list__filter')(
      (ToggleInputGroup()
        ..groupLabel = 'Todo List Filters'
        ..hideGroupLabel = true)(
        (CheckboxInput()
          ..defaultChecked = props.includePrivate
          ..label = 'Your Todos'
          ..onChange = (_) => props.actions.toggleIncludePrivate())(),
        (CheckboxInput()
          ..defaultChecked = props.includePublic
          ..label = 'Public Todos'
          ..onChange = (_) => props.actions.toggleIncludePublic())(),
        (CheckboxInput()
          ..defaultChecked = props.includeIncomplete
          ..label = 'Unfinished Todos'
          ..onChange = (_) => props.actions.toggleIncludeIncomplete())(),
        (CheckboxInput()
          ..defaultChecked = props.includeComplete
          ..label = 'Finished Todos'
          ..onChange = (_) => props.actions.toggleIncludeComplete())(),
      ),
    );
  }
}
