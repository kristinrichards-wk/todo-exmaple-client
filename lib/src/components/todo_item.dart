library todo_client.src.module.components.app;

import 'package:web_skin_dart/ui_components.dart';
import 'package:web_skin_dart/ui_core.dart';

import 'package:todo_sdk/todo_sdk.dart' show Todo;
import 'package:todo_client/src/actions.dart' show TodoActions;

@Factory()
UiFactory<TodoItemProps> TodoItem;

@Props()
class TodoItemProps extends UiProps {
  Todo todoItem;
  TodoActions actions;
}

@Component()
class TodoItemComponent extends UiComponent<TodoItemProps> {

  @override
  Map getDefaultProps() => (newProps()
    ..todoItem = null
  );

  @override
  render() {
    return (ListGroupItem()
      ..skin = props.todoItem.isCompleted? ListGroupItemSkin.SUCCESS : ListGroupItemSkin.DANGER
    )(
      Block()(
        // Block for checkbox and Item Description
        Block()(
          //status checkbox
          (BlockContent()
            ..shrink = true
          )(
            (CheckboxInput()
              ..hideLabel = true
              ..label = 'task status'
              ..onChange = _markComplete
            )(), 
          ),
          //item description
          (BlockContent()
            ..shrink = true
            ..onClick = (event) => print('toggle expand event')
          )(
            props.todoItem.description
          )
        ),

        // Block for privacy label and tool bar
        (Block()
          ..align = BlockAlign.END
        )(
          //privacy label
          (BlockContent()..shrink = true)
          (
            Label()(props.todoItem.isPublic ? 'public' : 'private')
          ),

          //tool bar link
          (BlockContent()..shrink = true)
          (
            (ButtonGroup()
              ..size = ButtonGroupSize.SMALL   
            )(
              // (ModalTrigger()
                
              // )(
                (Button()
                  ..skin = ButtonSkin.VANILLA
                  ..noText = true
                  ..onClick = _toggleEditModal
                )(
                  (Icon()..glyph = IconGlyph.PENCIL)()
                ),
              (Button()
                ..onClick = _togglePrivacy
                ..skin = ButtonSkin.VANILLA
                ..noText = true
              )(
                (Icon()..glyph = props.todoItem.isPublic ? IconGlyph.EYE : IconGlyph.EYE_BLOCKED)()
              ), 
              (Button()
                ..skin = ButtonSkin.VANILLA
                ..noText = true
                ..onClick = _deleteItem
              )(
                (Icon()..glyph = IconGlyph.TRASH)()
              )
            )
          )
        ),
      )
    );
  }

  _markComplete(event) {
    props.actions.updateTodo(props.todoItem.change(isCompleted: !props.todoItem.isCompleted));
  }

  _togglePrivacy(event) {
    props.actions.updateTodo(props.todoItem.change(isPublic: !props.todoItem.isPublic));
  }

  _deleteItem(event) {
    props.actions.deleteTodo(props.todoItem);
  }

  _toggleEditModal(event) {

  }

  _updateModal(event) {
   print(event.currentTarget);
  }
}