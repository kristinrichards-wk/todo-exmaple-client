library todo_client.src.module.components.app;

import 'package:web_skin_dart/ui_components.dart';
import 'package:web_skin_dart/ui_core.dart';

import 'package:todo_sdk/todo_sdk.dart' show Todo;
import 'package:todo_client/src/actions.dart' show TodoActions;
import 'package:todo_client/src/store.dart' show TodoStore;
import 'package:todo_client/src/components/todo_list.dart' show TodoList;

@Factory()
UiFactory<TodoAppProps> TodoApp;

@Props()
class TodoAppProps extends FluxUiProps<TodoActions, TodoStore> {
  String currentUserId;
  bool withFilter;
}

@Component()
class TodoAppComponent extends FluxUiComponent<TodoAppProps> {
  var inputRef;

  var _formRef;
    
      @override
      getDefaultProps() => (newProps()
        ..currentUserId = ''
        ..withFilter = true
      );
    
    
      submitItem() {
        props.actions.createTodo(new Todo(description: inputRef.getValue()));
        _formRef.reset();
      }
    
      @override
      render() {
        return (VBlock()..className = 'todo-app')(
          (BlockContent()
            ..shrink = true
            ..gutter = BlockGutter.BOTTOM //Figure out how to fix the styling on Scroll
            )((Form()
              ..onSubmit = ((_) => submitItem())
              ..ref = (ref) => _formRef = ref)(
              (TextInput()
                ..placeholder = 'What do you need to do?'
                ..label = 'What do you need to do?'
                ..autoFocus = true
                ..size = InputSize.LARGE
                ..hideLabel = true
                ..ref = (ref) => inputRef = ref)()
          )
      ),
          (BlockContent()
            ..gutter = BlockGutter.TOP
          )(
            (TodoList()
              ..actions = props.actions
              ..todoItems = props.store.todos
            )()
          ),
    );
  }
}
