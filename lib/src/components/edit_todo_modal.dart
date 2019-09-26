library todo_client.src.module.components.app;

import 'package:web_skin_dart/ui_components.dart';
import 'package:web_skin_dart/ui_core.dart';

import 'package:todo_sdk/todo_sdk.dart' show Todo;

@Factory()
UiFactory<EditTodoModalProps> EditTodoModal;

@Props()
class EditTodoModalProps extends UiProps {
  String header;
  Todo item;
  Function update;
}

@Component()
class EditTodoModalComponent extends UiComponent<EditTodoModalProps> {
  var _editModal;
  
  
  @override
  render() {
    (Modal()
      ..header = props.header
      ..backdropType = ModalBackdropType.DEFAULT
      ..ref = (inst) => _editModal = inst
    )(
      // Modal Body
      DialogBody()(
        Form()(
          (TextInput()
            ..defaultValue = props.item.description
            ..label = 'Item Description'
          )

        )
      ),
      
      //Modal Footer
      DialogFooter()(
        (Button()
          // close modal onclick
        )('Cancel'),

        (Button()
          ..skin = ButtonSkin.PRIMARY
          ..onClick = _updateItem
        )('Save Changes')
      ),
    );
  }

  _updateItem(event) {

  }

}
