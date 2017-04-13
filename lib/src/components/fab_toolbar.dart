import 'package:react/react_client/react_interop.dart';
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
class FabToolbarComponent extends UiStatefulComponent<FabToolbarProps, FabToolbarState> {
  getInitialState() => newState()..isOpen = false;

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
          _renderToolbarItems(),
        ),
      ),
    );
  }

  Iterable<ReactElement> _renderToolbarItems() sync* {
    for (var i = 0; i < props.children.length; i++) {
      var child = props.children[i];

      yield (BlockContent()
        ..onClick = (e) {
          // Prevent clicks from bubbling to the toolbar, resulting in it closing.
          if (e.currentTarget != e.target) {
            e.stopPropagation();
          }
        }
        ..key = i
        ..shrink = true
        ..scroll = false
        ..overflow = true)(
        child,
      );
    }
  }

  void toggle() => setState(newState()..isOpen = !state.isOpen);
}
