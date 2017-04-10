library todo_client.src.module.components.todo_list_item;

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
  String currentUserId;
  bool isExpanded;
  Todo todo;
}

@State()
class TodoListItemState extends UiState {
  bool isEditing;
}

@Component()
class TodoListItemComponent extends UiStatefulComponent<TodoListItemProps, TodoListItemState> {
  @override
  Map getDefaultProps() => (newProps()
    ..currentUserId = ''
    ..isExpanded = false
    ..todo = null);

  @override
  Map getInitialState() => (newState()..isEditing = false);

  @override
  render() {
    var classes = forwardingClassNameBuilder()
      ..add('todo')
      ..add(props.todo.isCompleted ? 'todo--complete' : 'todo--incomplete')
      ..add('todo-expanded', props.isExpanded);

    return (ListGroupItem()..className = classes.toClassName())(
      Block()(
        _renderCompletion(),
        _renderContents(),
        _renderControls(),
      ),
    );
  }

  ReactElement _renderCompletion() {
    return (BlockContent()
      ..className = 'todo-completion'
      ..shrink = true)(
      (Button()
        ..className = 'todo-check'
        ..isDisabled = !_canModify
        ..size = ButtonSize.XSMALL
        ..skin = ButtonSkin.VANILLA
        ..noText = true
        ..onClick = _toggleCompletion)(
        (Icon()..glyph = IconGlyph.CHECKMARK)(),
      ),
    );
  }

  ReactElement _renderContents() {
    return (BlockContent()..className = 'todo__contents')(
      (Dom.div()
        ..className = 'todo__title'
        ..onClick = _toggleExpansion)(
        props.todo.description,
        Label()(props.todo.isPublic ? 'public' : 'private'),
      ),
      (props.isExpanded && !_hasNotes)
          ? (Dom.div()..className = 'todo__notes todo__notes--empty')(
              Dom.em()('No notes.'),
            )
          : null,
      (props.isExpanded && _hasNotes)
          ? (Dom.div()..className = 'todo__notes')(props.todo.notes)
          : null,
    );
  }

  ReactElement _renderControls() {
    if (!_canModify) return null;

    ReactElement _renderControlButton(
        String className, MouseEventCallback onClick, IconGlyph glyph) {
      return (Button()
        ..className = className
        ..skin = ButtonSkin.VANILLA
        ..size = ButtonSize.XSMALL
        ..noText = true
        ..onClick = onClick)(
        (Icon()..glyph = glyph)(),
      );
    }

    return (BlockContent()
      ..shrink = true
      ..className = 'todo__controls')(
      (ButtonToolbar()..onClick = (e) => e.stopPropagation())(
        _renderControlButton('todo__edit-btn', _edit, IconGlyph.PENCIL),
        props.todo.isCompleted
            ? null
            : _renderControlButton('todo__privacy-btn', _togglePrivacy,
                props.todo.isPublic ? IconGlyph.EYE_BLOCKED : IconGlyph.EYE),
        props.todo.isCompleted
            ? null
            : _renderControlButton('todo__delete-btn', _delete, IconGlyph.TRASH),
      ),
    );
  }

  bool get _hasNotes => props.todo.notes != null && props.todo.notes.isNotEmpty;

  bool get _canModify => props.currentUserId == null || props.currentUserId == props.todo.userID;

  void _delete(e) {
    props.actions.deleteTodo(props.todo);
  }

  void _edit(e) {
    props.actions.editTodo(props.todo);
  }

  void _togglePrivacy(e) {
    props.actions.updateTodo(props.todo.change(isPublic: !props.todo.isPublic));
  }

  void _toggleExpansion(e) {
    e.stopPropagation();
    props.actions.selectTodo(props.isExpanded ? null : props.todo);
  }

  void _toggleCompletion(e) {
    e.stopPropagation();
    props.actions.updateTodo(props.todo.change(isCompleted: !props.todo.isCompleted));
  }
}
