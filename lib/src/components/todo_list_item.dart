library todo_example.src.module.components.todo_list_item;

import 'package:react/react.dart' as react;
import 'package:todo_sdk/todo_sdk.dart' show Todo;
import 'package:web_skin_dart/ui_core.dart';
import 'package:web_skin_dart/ui_components.dart';

import 'package:todo_example/src/actions.dart' show TodoActions;

var TodoListItem = react.registerComponent(() => new _TodoListItem());

class _TodoListItem extends react.Component {
  Todo edited;

  TodoActions get actions => props['actions'];
  String get currentUserID => props['currentUserID'];
  bool get isEditing => state['isEditing'];
  bool get isExpanded => props['isExpanded'];
  Todo get todo => props['todo'];

  getInitialState() => {'isEditing': false};

  render() {
    var todoTitle = [todo.description];
    if (todo.isPublic) {
      todoTitle.add(Label()('public'));
    }

    var todoContents = [];
    todoContents.add((Dom.p()
      ..className = 'todo-title'
      ..onClick = _toggleExpansion)(todoTitle));
    if (isExpanded) {
      if (todo.notes == null || todo.notes.isEmpty) {
        todoContents.add((Dom.p()..className = 'todo-notes todo-notes-empty')('No notes.'));
      } else {
        todoContents.add((Dom.p()..className = 'todo-notes')(todo.notes));
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
          ..glyph = IconGlyph.PENCIL
          ..onClick = _edit)(),
        (Icon()
          ..className = 'todo-privacy'
          ..glyph = todo.isPublic ? IconGlyph.EYE_BLOCKED : IconGlyph.EYE
          ..onClick = _togglePrivacy)(),
        (Icon()
          ..className = 'todo-delete'
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
    todoClass += todo.isCompleted ? ' todo-complete' : ' todo-incomplete';
    todoClass += isExpanded ? ' todo-expanded' : '';

    return (Block()
      ..className = todoClass
      ..key = todo.id
      ..shrink = true)([
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
        ..shrink = true)(todoControls),
    ]);
  }

  bool _canModify() => currentUserID == null || currentUserID == todo.userID;

  _delete(e) {
    e.preventDefault();
    e.stopPropagation();

    actions.deleteTodo(todo);
  }

  _edit(e) {
    e.preventDefault();
    e.stopPropagation();

    actions.editTodo(todo);
  }

  _togglePrivacy(e) {
    e.preventDefault();
    e.stopPropagation();

    actions.updateTodo(todo.change(isPublic: !todo.isPublic));
  }

  _toggleExpansion(e) {
    e.preventDefault();
    e.stopPropagation();

    if (isExpanded) {
      actions.selectTodo(null);
    } else {
      actions.selectTodo(todo);
    }
  }

  _toggleCompletion(e) {
    e.preventDefault();
    e.stopPropagation();

    actions.updateTodo(todo.change(isCompleted: !todo.isCompleted));
  }
}
