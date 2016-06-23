library todo_client.src.module.components.todo_list_item;

import 'package:todo_sdk/todo_sdk.dart' show Todo;
import 'package:web_skin_dart/ui_core.dart';
import 'package:web_skin_dart/ui_components.dart';

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
  Todo edited;

  @override
  getDefaultProps() => (newProps()
    ..currentUserId = ''
    ..isExpanded = false
    ..todo = null);

  @override
  getInitialState() => (newState()..isEditing = false);

  @override
  render() {
    var todoContents = [];
    todoContents.add((Dom.p()
      ..className = 'todo-title'
      ..key = 'todo-title'
      ..onClick = _toggleExpansion)((Dom.span())(props.todo.description),
        (Label())(props.todo.isPublic ? 'public' : 'private')));
    if (props.isExpanded) {
      if (props.todo.notes == null || props.todo.notes.isEmpty) {
        todoContents.add((Dom.p()
          ..className = 'todo-notes todo-notes-empty'
          ..key = 'todo-notes-empty')('No notes.'));
      } else {
        todoContents.add((Dom.p()
          ..className = 'todo-notes'
          ..key = 'todo-notes')(props.todo.notes));
      }
    }

    var todoCompletion;
    var todoControls;

    if (_canModify()) {
      todoCompletion = (Icon()
        ..className = 'todo-check'
        ..glyph = IconGlyph.CHECKMARK
        ..onClick = _toggleCompletion)();

      todoControls = [
        (Icon()
          ..className = 'todo-edit'
          ..key = 'todo-edit'
          ..glyph = IconGlyph.PENCIL
          ..onClick = _edit)(),
        (Icon()
          ..className = 'todo-privacy'
          ..key = 'todo-privacy'
          ..glyph = props.todo.isPublic ? IconGlyph.EYE_BLOCKED : IconGlyph.EYE
          ..onClick = _togglePrivacy)(),
        (Icon()
          ..className = 'todo-delete'
          ..key = 'todo-delete'
          ..glyph = IconGlyph.TRASH
          ..onClick = _delete)(),
      ];
    } else {
      todoCompletion = (Icon()
        ..className = 'todo-check-inactive'
        ..glyph = IconGlyph.CHECKMARK)();

      todoControls = [];
    }

    var todoClass = 'todo';
    todoClass += props.todo.isCompleted ? ' todo-complete' : ' todo-incomplete';
    todoClass += props.isExpanded ? ' todo-expanded' : '';

    return (Block()
      ..className = todoClass
      ..key = props.todo.id
      ..shrink = true)(
        (Block()
          ..className = 'todo-completion'
          ..isNested = true
          ..shrink = true)(todoCompletion),
        (Block()
          ..className = 'todo-contents'
          ..isNested = true
          ..wrap = true)(todoContents),
        (Block()
          ..className = 'todo-controls'
          ..isNested = true
          ..shrink = true)(todoControls));
  }

  bool _canModify() => props.currentUserId == null || props.currentUserId == props.todo.userID;

  _delete(e) {
    e.preventDefault();
    e.stopPropagation();

    props.actions.deleteTodo(props.todo);
  }

  _edit(e) {
    e.preventDefault();
    e.stopPropagation();

    props.actions.editTodo(props.todo);
  }

  _togglePrivacy(e) {
    e.preventDefault();
    e.stopPropagation();

    props.actions.updateTodo(props.todo.change(isPublic: !props.todo.isPublic));
  }

  _toggleExpansion(e) {
    e.preventDefault();
    e.stopPropagation();

    if (props.isExpanded) {
      props.actions.selectTodo(null);
    } else {
      props.actions.selectTodo(props.todo);
    }
  }

  _toggleCompletion(e) {
    e.preventDefault();
    e.stopPropagation();

    props.actions.updateTodo(props.todo.change(isCompleted: !props.todo.isCompleted));
  }
}
