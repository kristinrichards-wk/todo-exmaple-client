import 'dart:html';

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
  bool isHovered;
  bool isChildFocused;
}

@Component()
class TodoListItemComponent extends UiStatefulComponent<TodoListItemProps, TodoListItemState> {
  @override
  Map getDefaultProps() => (newProps()
    ..currentUserId = ''
    ..isExpanded = false
    ..todo = null);

  @override
  Map getInitialState() => (newState()
    ..isHovered = false
    ..isChildFocused = false);

  @override
  render() {
    var classes = forwardingClassNameBuilder()
      ..add('todo-list__item')
      ..add('todo-list__item--complete', props.todo.isCompleted)
      ..add('todo-list__item--incomplete', !props.todo.isCompleted)
      ..add('todo-list__item--expanded', props.isExpanded);

    return (ListGroupItem()
      ..className = classes.toClassName()
      ..onMouseEnter = _handleItemMouseEnter
      ..onMouseLeave = _handleItemMouseLeave
      ..onFocus = _handleChildFocus
      ..onBlur = _handleChildBlur)(
      // Row 1: Checkmark, title, edit button
      Dom.div()(
        Block()(
          // Row 1, Column 1: "shrink-wrapped" width (checkbox)
          (Block()
            ..className = 'todo-list__item__block todo-list__item__checkbox-block'
            ..shrink = true)(
            _renderTaskCheckbox(),
          ),
          // Row 1, Column 2: (task name)
          (BlockContent()
            ..className = 'todo-list__item__block todo-list__item__header-block'
            ..collapse = BlockCollapse.VERTICAL)(
            _renderTaskHeader(),
          ),
          // Row 1, Column 3: (task labels)
          (BlockContent()
            ..className = 'todo-list__item__block todo-list__item__labels-block'
            ..collapse = BlockCollapse.ALL
            ..shrink = true)(
            _renderTaskLabels(),
          ),
          // Row 1, Column 4: "shrink-wrapped" width (edit button)
          (BlockContent()
            ..className = 'todo-list__item__block todo-list__item__controls-block'
            ..collapse = BlockCollapse.VERTICAL | BlockCollapse.RIGHT
            ..shrink = true)(
            _renderTaskControlsToolbar(),
          ),
        ),
      ),
      // Row 2: Notes (collapsed by default)
      _renderTaskNotes(),
    );
  }

  ReactElement _renderTaskCheckbox() {
    return (CheckboxInput()
      ..checked = props.todo.isCompleted
      ..isDisabled = !_canModify
      ..label = 'Complete Task'
      ..hideLabel = true
      // In theory this would be some unique id that your app could keep track of for data persistence
      ..value = ''
      ..onChange = _toggleCompletion)();
  }

  ReactElement _renderTaskHeader() {
    return (Dom.div()
      ..role = Role.button
      ..onClick = _toggleExpansion)(
      props.todo.description,
    );
  }

  ReactElement _renderTaskLabels() {
    return Label()(props.todo.isPublic ? 'public' : 'private');
  }

  ReactElement _renderTaskNotes() {
    if (!props.isExpanded) return null;

    return (Dom.div()..className = 'todo-list__item__notes')(
      _hasNotes ? props.todo.notes : (Dom.em()..className = 'text-muted')('No notes.'),
    );
  }

  ReactElement _renderTaskControlsToolbar() {
    _plainButtonFactory() => Button()
      ..skin = ButtonSkin.VANILLA
      ..size = ButtonSize.XSMALL
      ..noText = true;

    var edit = (_plainButtonFactory()
      ..className = 'todo-list__item__edit-btn'
      ..onClick = _edit
      ..isDisabled = !_canModify)(
      (Icon()..glyph = IconGlyph.PENCIL)(),
    );

    var privacy = (_plainButtonFactory()
      ..className = 'todo-list__item__privacy-btn'
      ..onClick = _togglePrivacy
      ..isDisabled = !_canModify || props.todo.isCompleted)(
      (Icon()..glyph = props.todo.isPublic ? IconGlyph.EYE : IconGlyph.EYE_BLOCKED)(),
    );

    var delete = (_plainButtonFactory()
      ..className = 'todo-list__item__delete-btn'
      ..onClick = _delete
      ..isDisabled = !_canModify || props.todo.isCompleted)(
      (Icon()..glyph = IconGlyph.TRASH)(),
    );

    return (ButtonToolbar()
      ..className = 'todo-list__item__controls-toolbar'
      ..addProps(ariaProps()..hidden = !_isHovered))(
      edit,
      privacy,
      delete,
    );
  }

  bool get _canModify => props.currentUserId == null || props.currentUserId == props.todo.userID;

  bool get _hasNotes => props.todo.notes != null && props.todo.notes.isNotEmpty;

  bool get _isHovered => state.isHovered || state.isChildFocused;

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
    props.actions.selectTodo(props.isExpanded ? null : props.todo);
  }

  void _toggleCompletion(react.SyntheticFormEvent event) {
    props.actions.updateTodo(props.todo.change(isCompleted: !props.todo.isCompleted));
  }

  void _handleItemMouseEnter(react.SyntheticMouseEvent event) {
    setState(newState()..isHovered = true);
  }

  void _handleItemMouseLeave(react.SyntheticMouseEvent event) {
    setState(newState()..isHovered = false);
  }

  void _handleChildFocus(react.SyntheticFocusEvent event) {
    setState(newState()..isChildFocused = true);
  }

  void _handleChildBlur(react.SyntheticFocusEvent event) {
    var newlyFocusedTarget = event.relatedTarget;
    // newlyFocusedTarget could be null or a window, so check if it's an Element first.
    if (newlyFocusedTarget is Element && findDomNode(this).contains(newlyFocusedTarget)) {
      // Don't do anything if we're moving from one item to another
      return;
    }

    setState(newState()..isChildFocused = false);
  }
}
