import 'dart:html';

import 'package:web_skin_dart/ui_components.dart';
import 'package:web_skin_dart/ui_core.dart';

@Factory()
UiFactory<FabToolbarProps> FabToolbar;

@Props()
class FabToolbarProps extends UiProps {
  dynamic buttonContent;
}

@State()
class FabToolbarState extends UiState {
  bool isOpen;
}

@Component()
class FabToolbarComponent extends UiStatefulComponent<FabToolbarProps, FabToolbarState>
    with RootCloseHandlersMixin {
  @override
  Map getInitialState() => newState()..isOpen = false;

  @override
  void componentWillUpdate(Map nextProps, Map nextState) {
    super.componentWillUpdate(nextProps, nextState);

    var tNextState = typedStateFactory(nextState);
    tNextState.isOpen ? bindRootCloseHandlers() : unbindRootCloseHandlers();
  }

  @override
  void componentWillUnmount() {
    super.componentWillUnmount();

    unbindRootCloseHandlers();
  }

  @override
  render() {
    var classes = forwardingClassNameBuilder()
      ..add('fab-toolbar fab-toolbar--primary')
      ..add('fab-toolbar--open', state.isOpen)
      ..blacklist('btn');

    return (Button()
      ..skin = ButtonSkin.VANILLA
      ..className = classes.toClassName()
      ..classNameBlacklist = classes.toClassNameBlacklist()
      ..onClick = (_) {
        toggle();
      })(
      (Dom.div()..className = 'fab-toolbar__content')(props.buttonContent),
      (Dom.div()..className = 'fab-toolbar--open__content')(
        (Block()
          ..scroll = true
          ..align = BlockAlign.CENTER)(
          (ToggleButtonGroup()
            ..size = ButtonGroupSize.LARGE
            ..skin = ButtonSkin.LINK
            ..hideGroupLabel = true
            ..groupLabel = 'Filter Options')(
            props.children,
          ),
        ),
      ),
    );
  }

  void toggle() => setState(newState()..isOpen = !state.isOpen);

  void close() => setState(newState()..isOpen = false);

  void open() => setState(newState()..isOpen = true);

  @override
  void handleCapturingDocumentFocus(FocusEvent event) {
    if (event.target is! Element || !findDomNode(this).contains(event.target)) {
      close();
    }
  }

  @override
  void handleDocumentClick(MouseEvent event) {
    if (event.target is Element && !findDomNode(this).contains(event.target)) {
      close();
    }
  }

  @override
  void handleDocumentKeyDown(KeyboardEvent event) {
    if (event.keyCode == KeyCode.ESC) {
      close();
    }
  }
}
