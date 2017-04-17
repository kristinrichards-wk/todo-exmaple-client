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
  bool isHovered;
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
    ..isHovered = false
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
      ..add('todo-list__item--expanded', props.isExpanded)
      ..add('todo-list__item--hovered', state.isHovered || state.isChildFocused);

    return (ListGroupItem()
      ..className = classes.toClassName()
      ..onMouseEnter = _handleItemMouseEnter
      ..onMouseLeave = _handleItemMouseLeave)(
      // Row 1: Checkmark, title, edit button
      Dom.div()(Block()(
        // Row 1, Column 1: "shrink-wrapped" width (checkbox)
        (Block()
          ..className = 'todo-list__item__block todo-list__item__checkbox-block'
          ..shrink = true)(
          _renderTaskCheckbox(),
        ),
        // Row 1, Column 2: (task name)
        (BlockContent()
          ..className = 'todo-list__item__block todo-list__item__header-block'
          ..collapse = BlockCollapse.VERTICAL
          ..scroll = false
          ..overflow = true)(
          _renderTaskHeader(),
        ),
        // Row 1, Column 3: (task labels)
        (BlockContent()
          ..className = 'todo-list__item__block todo-list__item__labels-block'
          ..collapse = BlockCollapse.ALL
          ..shrink = true
          ..overflow = true)(
          _renderTaskLabels(),
        ),
        // Row 1, Column 4: "shrink-wrapped" width (edit button)
        (BlockContent()
          ..className = 'todo-list__item__block todo-list__item__controls-block'
          ..collapse = BlockCollapse.VERTICAL | BlockCollapse.RIGHT
          ..shrink = true
          ..overflow = true)(
          _renderTaskControlsToolbar(),
        ),
      )),
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
      ..onChange = _toggleCompletion
      ..onFocus = _handleChildFocus
      ..onBlur = _handleChildBlur)();
  }

  ReactElement _renderTaskHeader() {
    var hintContent = props.isExpanded ? 'Click to hide task notes' : 'Click to show task notes';

    return (OverlayTrigger()
      ..overlay = Tooltip()(hintContent)
      ..placement = OverlayPlacement.TOP_RIGHT
      ..delayShow = 1000
      ..useLegacyPositioning = false
      ..trigger = OverlayTriggerType.HOVER)(
      (Dom.div()
        ..role = Role.button
        ..onClick = _toggleExpansion)(
        props.todo.description,
      ),
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
    return ButtonToolbar()(
      _renderEditTaskButton(),
      _renderTogglePrivacyButton(),
      _renderDeleteButton(),
    );
  }

  ReactElement _renderEditTaskButton() {
    return _renderTaskControlButton(
        IconGlyph.PENCIL, 'Edit Task', 'todo-list__item__edit-btn', _edit);
  }

  ReactElement _renderTogglePrivacyButton() {
    var glyph = props.todo.isPublic ? IconGlyph.EYE : IconGlyph.EYE_BLOCKED;
    var label = props.todo.isPublic ? 'Make Private' : 'Make Public';

    return _renderTaskControlButton(glyph, label, 'todo-list__item__privacy-btn', _togglePrivacy);
  }

  ReactElement _renderDeleteButton() {
    return _renderTaskControlButton(
        IconGlyph.TRASH, 'Delete Task', 'todo-list__item__delete-btn', _delete);
  }

  ReactElement _renderTaskControlButton(
      IconGlyph glyph, String label, String className, MouseEventCallback onClick) {
    return (OverlayTrigger()
      ..overlay = (Tooltip()..arrowVisible = true)(label)
      ..placement = OverlayPlacement.TOP
      ..useLegacyPositioning = false)(
      (Button()
        ..className = className
        ..skin = ButtonSkin.VANILLA
        ..size = ButtonSize.XSMALL
        ..noText = true
        ..onClick = onClick
        ..isDisabled = !_canModify
        ..onFocus = _handleChildFocus
        ..onBlur = _handleChildBlur
        ..addProps(ariaProps()
          ..label = label
          ..hidden = !_canModify || (!state.isHovered && !state.isChildFocused)))(
        (Icon()..glyph = glyph)(),
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

  void _toggleCompletion(react.SyntheticFormEvent event) {
    props.actions.updateTodo(props.todo.change(isCompleted: !props.todo.isCompleted));
  }

  void _handleItemMouseEnter(react.SyntheticMouseEvent event) {
    if (!state.isHovered) setState(newState()..isHovered = true);
  }

  void _handleItemMouseLeave(react.SyntheticMouseEvent event) {
    if (state.isHovered) setState(newState()..isHovered = false);
  }

  void _handleChildFocus(react.SyntheticFocusEvent event) {
    if (!state.isChildFocused) setState(newState()..isChildFocused = true);
  }

  void _handleChildBlur(react.SyntheticFocusEvent event) {
    if (event.relatedTarget == null) return;

    if (closest(event.relatedTarget, '.todo-list__item', upperBound: findDomNode(this)) != null) {
      if (state.isChildFocused) setState(newState()..isChildFocused = false);
    }
  }
}
