library todo_client.src.module.components.todo_list_item;

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
      ..add('todo-list__item')
      ..add(props.todo.isCompleted ? 'todo-list__item--complete' : 'todo-list__item--incomplete')
      ..add('todo-list__item--expanded', props.isExpanded);

    return (ListGroupItem()..className = classes.toClassName())(
      _renderCompletion(),
      _renderContents(),
      _renderControls(),
    );
  }

  ReactElement _renderCompletion() {
    return (BlockContent()
      ..className = 'todo-list__item__completion-indicator'
      ..collapse = BlockCollapse.ALL
      ..shrink = true
      // Prevent clipping of Button focus border
      ..overflow = true)(
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
    return (BlockContent()
      ..className = 'todo-list__item__contents'
      ..collapse = BlockCollapse.VERTICAL)(
      (Dom.div()
        ..className = 'todo-list__item__title'
        ..onClick = _toggleExpansion)(
        props.todo.description,
        Label()(props.todo.isPublic ? 'public' : 'private'),
      ),
      props.isExpanded
          ? (Dom.div()..className = 'todo-list__item__notes')(
              _hasNotes ? props.todo.notes : Dom.em()('No notes.'),
            )
          : null,
    );
  }

  ReactElement _renderControls() {
    if (!_canModify) return null;

    _renderControl(String className, MouseEventCallback onClick, IconGlyph glyph) {
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
      ..className = 'todo-list__item__controls'
      ..collapse = BlockCollapse.ALL
      ..shrink = true
      // Prevent clipping of Button focus border
      ..overflow = true)(
      (ButtonToolbar()
        ..onClick = (e) {
          // Prevent clicks from expanding/collapsing the item
          e.stopPropagation();
        })(
        _renderControl('todo-list__item__edit-btn', _edit, IconGlyph.PENCIL),
        props.todo.isCompleted
            ? null
            : _renderControl('todo-list__item__privacy-btn', _togglePrivacy,
                props.todo.isPublic ? IconGlyph.EYE_BLOCKED : IconGlyph.EYE),
        props.todo.isCompleted
            ? null
            : _renderControl('todo-list__item__delete-btn', _delete, IconGlyph.TRASH),
      ),
    );
  }

  bool get _canModify => props.currentUserId == null || props.currentUserId == props.todo.userID;

  bool get _hasNotes => props.todo.notes != null && props.todo.notes.isNotEmpty;

  void _delete(_) {
    props.actions.deleteTodo(props.todo);
  }

  void _edit(_) {
    props.actions.editTodo(props.todo);
  }

  void _togglePrivacy(_) {
    props.actions.updateTodo(props.todo.change(isPublic: !props.todo.isPublic));
  }

  void _toggleExpansion(react.SyntheticMouseEvent event) {
    event.stopPropagation();
    props.actions.selectTodo(props.isExpanded ? null : props.todo);
  }

  void _toggleCompletion(react.SyntheticMouseEvent event) {
    event.stopPropagation();
    props.actions.updateTodo(props.todo.change(isCompleted: !props.todo.isCompleted));
  }
}
