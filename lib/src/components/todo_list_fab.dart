import 'package:react/react_client.dart';
import 'package:todo_client/src/actions.dart';
import 'package:todo_client/src/store.dart';
import 'package:web_skin_dart/ui_components.dart';
import 'package:web_skin_dart/ui_core.dart';
import 'package:todo_client/src/components/fab_toolbar.dart';

@Factory()
UiFactory<TodoListFabProps> TodoListFab;

@Props()
class TodoListFabProps extends UiProps {
  TodoActions actions;
  TodoStore store;
}

@Component()
class TodoListFabComponent extends UiComponent<TodoListFabProps> {
  @override
  render() {
    return (FabToolbar()
      ..addProps(copyUnconsumedProps())
      ..buttonContent = (Icon()..glyph = IconGlyph.FILTER)())(
      _renderFabButton(
        name: 'Your Todos',
        glyph: IconGlyph.FOLDER,
        isActive: props.store.includePrivate,
        onClick: (e) => props.actions.toggleIncludePrivate(),
      ),
      _renderFabButton(
        name: 'Public Todos',
        glyph: IconGlyph.FOLDER_OPEN,
        isActive: props.store.includePublic,
        onClick: (e) => props.actions.toggleIncludePublic(),
      ),
      _renderFabButton(
        name: 'Unfinished Todos',
        glyph: IconGlyph.CHECKMARK,
        isActive: props.store.includeIncomplete,
        onClick: (e) => props.actions.toggleIncludeIncomplete(),
      ),
      _renderFabButton(
        name: 'Finished Todos',
        glyph: IconGlyph.TASK_CREATE,
        isActive: props.store.includeComplete,
        onClick: (e) => props.actions.toggleIncludeComplete(),
      ),
    );
  }

  ReactElement _renderFabButton({
    String name,
    bool isActive,
    MouseEventCallback onClick,
    IconGlyph glyph,
  }) {
    return (OverlayTrigger()
      ..overlay = Tooltip()(name)
      ..placement = OverlayPlacement.TOP)(
      (Button()
        ..size = ButtonSize.LARGE
        ..noText = true
        ..isActive = isActive
        ..onClick = onClick)(
        (Icon()..glyph = glyph)(),
      ),
    );
  }
}
