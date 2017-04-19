import 'package:react/react.dart' as react;
import 'package:react/react_client.dart';
import 'package:todo_sdk/todo_sdk.dart' show Todo;
import 'package:web_skin_dart/ui_components.dart';
import 'package:web_skin_dart/ui_core.dart';

import 'package:todo_client/src/actions.dart' show TodoActions;

@Factory()
UiFactory<TodoListItemProps> TodoListItem;

@Props()
class TodoListItemProps extends UiProps {
  TodoActions actions;
  Todo todo;
}

@Component()
class TodoListItemComponent extends UiComponent<TodoListItemProps> {
  @override
  Map getDefaultProps() => (newProps());

  @override
  render() {
    var classes = forwardingClassNameBuilder()
      ..add('todo-list__item')
      ..add('todo-list__item--complete', props.todo.isCompleted)
      ..add('todo-list__item--incomplete', !props.todo.isCompleted);

    return (ListGroupItem()..className = classes.toClassName())(
      Block()(
        // Row 1, Column 1: "shrink-wrapped" width (checkbox)
        (Block()..shrink = true)(
          _renderTaskCheckbox(),
        ),
        // Row 1, Column 2: (task name)
        BlockContent()(
          _renderTaskHeader(),
        ),
      ),
    );
  }

  ReactElement _renderTaskCheckbox() {
    return (CheckboxInput()
      ..checked = props.todo.isCompleted
      ..label = 'Complete Task'
      ..hideLabel = true
      // In theory this would be some unique id that your app could keep track of for data persistence
      ..value = ''
      ..onChange = _toggleCompletion)();
  }

  ReactElement _renderTaskHeader() {
    return Dom.div()(
      props.todo.description,
    );
  }

  void _toggleCompletion(react.SyntheticFormEvent event) {
    props.actions.updateTodo(props.todo.change(isCompleted: !props.todo.isCompleted));
  }
}
