import 'package:meta/meta.dart';
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
          glyph: IconGlyph.USER,
          isActive: props.store.includePrivate,
          onChange: ((_) => props.actions.toggleIncludePrivate())),
      _renderFabButton(
          name: 'Public Todos',
          glyph: IconGlyph.USERS,
          isActive: props.store.includePublic,
          onChange: ((_) => props.actions.toggleIncludePublic())),
      _renderFabButton(
          name: 'Unfinished Todos',
          glyph: IconGlyph.TIE_OUT_UNTIED,
          isActive: props.store.includeIncomplete,
          onChange: ((_) => props.actions.toggleIncludeIncomplete())),
      _renderFabButton(
          name: 'Finished Todos',
          glyph: IconGlyph.TIE_OUT_TIED,
          isActive: props.store.includeComplete,
          onChange: ((_) => props.actions.toggleIncludeComplete())),
    );
  }

  ReactElement _renderFabButton({
    @required String name,
    @required bool isActive,
    @required FormEventCallback onChange,
    @required IconGlyph glyph,
  }) {
    return (OverlayTrigger()
      ..overlay = Tooltip()(name)
      ..placement = OverlayPlacement.TOP)(
      (CheckboxButton()
        ..addProps(ariaProps()..label = name)
        ..noText = true
        ..checked = isActive
        ..onChange = onChange)(
        (Icon()..glyph = glyph)(),
      ),
    );
  }
}
