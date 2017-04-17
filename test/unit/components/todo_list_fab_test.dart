import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:web_skin_dart/test_util.dart';
import 'package:web_skin_dart/ui_core.dart';
import 'package:web_skin_dart/ui_components.dart';

import 'package:todo_client/src/components/todo_list_fab.dart';
import 'package:todo_client/src/components/fab_toolbar.dart';

import '../mocks.dart';

main() {
  group('TodoListFab', () {
    verifyFabButton(instance, {
      @required String name,
      @required bool isActive,
      @required Function verifyOnClickCalled(),
      @required IconGlyph glyph
    }) {
      var overlayTriggerProps = OverlayTrigger(getPropsByTestId(instance, 'todoListFab.overlayTrigger.${name.replaceAll(' ', '')}'));
      var buttonProps = Button(getPropsByTestId(instance, 'todoListFab.button.${name.replaceAll(' ', '')}'));
      var iconProps = Icon(getPropsByTestId(instance, 'todoListFab.icon.${name.replaceAll(' ', '')}'));

      expect(Tooltip(getProps(overlayTriggerProps.overlay)).children, [name]);
      expect(overlayTriggerProps.placement, OverlayPlacement.TOP);

      expect(buttonProps.size, ButtonSize.LARGE);
      expect(buttonProps.noText, isTrue);
      expect(buttonProps.isActive, isActive);

      click(queryByTestId(instance, 'todoListFab.button.${name.replaceAll(' ', '')}'));
      verifyOnClickCalled();

      expect(iconProps.glyph, glyph);
    }

    test('renders a Fabtoolbar with correct props', () {
      var actions = new MockTodoActions();
      var store = new MockTodoStore();

      when(store.includePrivate).thenReturn(false);
      when(store.includePublic).thenReturn(true);
      when(store.includeIncomplete).thenReturn(false);
      when(store.includeComplete).thenReturn(true);

      var instance = render((TodoListFab()
        ..actions = actions
        ..store = store
      )());
      var fabToolbarProps = FabToolbar(getPropsByTestId(instance, 'todoListFab.fabToolbar'));

      expect(Icon(getProps(fabToolbarProps.buttonContent)).glyph, IconGlyph.FILTER);
      expect(fabToolbarProps.children, hasLength(4));

      verifyFabButton(instance,
        name: 'Your Todos',
        isActive: false,
        verifyOnClickCalled: () {
          verify(actions.toggleIncludePrivate()).called(1);
        },
        glyph: IconGlyph.FOLDER,
      );

      verifyFabButton(instance,
        name: 'Public Todos',
        isActive: true,
        verifyOnClickCalled: () {
          verify(actions.toggleIncludePublic()).called(1);
        },
        glyph: IconGlyph.FOLDER_OPEN,
      );

      verifyFabButton(instance,
        name: 'Unfinished Todos',
        isActive: false,
        verifyOnClickCalled: () {
          verify(actions.toggleIncludeIncomplete()).called(1);
        },
        glyph: IconGlyph.CHECKMARK,
      );

      verifyFabButton(instance,
        name: 'Finished Todos',
        isActive: true,
        verifyOnClickCalled: () {
          verify(actions.toggleIncludeComplete()).called(1);
        },
        glyph: IconGlyph.TASK_CREATE,
      );
    });
  });
}
