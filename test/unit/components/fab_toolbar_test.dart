import 'dart:html';

import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:w_test_tools/src/key_event_util.dart';
import 'package:w_test_tools/src/mock_classes.dart';
import 'package:web_skin_dart/test_util.dart';
import 'package:web_skin_dart/ui_core.dart';
import 'package:web_skin_dart/ui_components.dart';

import 'package:todo_client/src/components/fab_toolbar.dart';

main() {
  group('FabToolbar', () {
    group('renders a Button with correct props', () {
      test('by default', () {
        var instance = render(FabToolbar()());
        var buttonProps = Button(getPropsByTestId(instance, 'fabToolbar.button'));

        expect(buttonProps.className, 'fab-toolbar fab-toolbar--primary');
        expect(buttonProps.classNameBlacklist, 'btn');
        expect(buttonProps.skin, ButtonSkin.VANILLA);
        expect(buttonProps.onClick, isNotNull);
      });

      test('when state.isOpen is true', () {
        var instance = render(FabToolbar()());
        FabToolbarComponent dartInstance = getDartComponent(instance);

        dartInstance.open();

        var buttonProps = Button(getPropsByTestId(instance, 'fabToolbar.button'));

        expect(buttonProps.className, 'fab-toolbar fab-toolbar--primary fab-toolbar--open');
        expect(buttonProps.classNameBlacklist, 'btn');
        expect(buttonProps.skin, ButtonSkin.VANILLA);
        expect(buttonProps.onClick, isNotNull);
      });
    });

    test('renders closed content correctly', () {
      var instance = render((FabToolbar()..buttonContent = 'Content')());
      var contentNode = queryByTestId(instance, 'fabToolbar.content');

      expect(contentNode, hasExactClasses('fab-toolbar__content'));
      expect(contentNode.text, 'Content');
    });

    test('renders opened content correctly', () {
      var instance = render(FabToolbar()(
        (Button()..addTestId('firstToolbarChild'))(),
      ));
      var openContentNode = queryByTestId(instance, 'fabToolbar.openContent');
      var openContentBlockNode = queryByTestId(instance, 'fabToolbar.openContentBlock');
      var openContentBlockProps = Block(getPropsByTestId(instance, 'fabToolbar.openContentBlock'));
      var fabToolbarItem1Node = queryByTestId(instance, 'fabToolbar.toolbarItem.0');
      var fabToolbarItem1Props = BlockContent(getPropsByTestId(instance, 'fabToolbar.toolbarItem.0'));

      expect(openContentNode, hasExactClasses('fab-toolbar--open__content'));
      expect(openContentNode.children, hasLength(1));
      expect(openContentNode.children.single, openContentBlockNode);

      expect(openContentBlockProps.scroll, isTrue);
      expect(openContentBlockProps.align, BlockAlign.CENTER);
      expect(openContentBlockNode.children, hasLength(1));
      expect(openContentBlockNode.children.single, fabToolbarItem1Node);

      expect(fabToolbarItem1Props.onClick, isNotNull);
      expect(fabToolbarItem1Props.shrink, isTrue);
      expect(fabToolbarItem1Props.scroll, false);
      expect(fabToolbarItem1Props.overflow, true);
      expect(fabToolbarItem1Node.children, hasLength(1));
      expect(fabToolbarItem1Node.children.single, queryByTestId(instance, 'firstToolbarChild'));
    });

    group('correctly handles events', () {
      setUpAll(() {
        var bodySpy = spy(new MockElement(), document.body);
        setUpElementKeyEventListeners(bodySpy, useCapture: true);

        var documentSpy = spy(new MockDocument(), document);

        DocumentEventHelper.document = documentSpy;
        when(documentSpy.body).thenReturn(bodySpy);
      });

      tearDownAll(() {
        tearDownDocKeyEventListeners();
      });

      tearDown(() {
        tearDownAttachedNodes();
      });

      test('when clicking the Button', () {
        var instance = renderAttachedToDocument(FabToolbar()());
        var node = findDomNode(instance);
        FabToolbarComponent dartInstance = getDartComponent(instance);

        expect(dartInstance.state.isOpen, isFalse);

        click(node);

        expect(dartInstance.state.isOpen, isTrue);

        click(node);

        expect(dartInstance.state.isOpen, isFalse);
      });

      test('when clicking a toolbar item', () {
        var stopPropagationCalled = false;
        var instance = renderAttachedToDocument(FabToolbar()(
          (Button()..addTestId('firstToolbarChild'))(),
        ));
        var toolbarItem1Node = queryByTestId(instance, 'fabToolbar.toolbarItem.0');

        click(toolbarItem1Node, {
          'target': new DivElement(),
          'currentTarget': new DivElement(),
          'stopPropagation': () {
            stopPropagationCalled = true;
          },
        });

        expect(stopPropagationCalled, isTrue);
      });

      test('when focusing an element outside the FAB', () {
        var instance = renderAttachedToDocument(Wrapper()(
          (Dom.input()..addTestId('input'))(),
          (FabToolbar()..addTestId('fabToolbar'))(),
        ));
        FabToolbarComponent fabToolbarDartInstance = getComponentByTestId(instance, 'fabToolbar');
        var inputNode = queryByTestId(instance, 'input');

        expect(fabToolbarDartInstance.state.isOpen, isFalse);

        fabToolbarDartInstance.open();

        expect(fabToolbarDartInstance.state.isOpen, isTrue);

        inputNode.focus();

        expect(fabToolbarDartInstance.state.isOpen, isFalse);
      });

      test('when clicking an element outsize the FAB', () {
        var instance = renderAttachedToDocument(Wrapper()(
          (Dom.input()..addTestId('input'))(),
          (FabToolbar()..addTestId('fabToolbar'))(),
        ));
        FabToolbarComponent fabToolbarDartInstance = getComponentByTestId(instance, 'fabToolbar');
        var inputNode = queryByTestId(instance, 'input');

        expect(fabToolbarDartInstance.state.isOpen, isFalse);

        fabToolbarDartInstance.open();

        expect(fabToolbarDartInstance.state.isOpen, isTrue);

        inputNode.click();

        expect(fabToolbarDartInstance.state.isOpen, isFalse);
      });

      test('pressing ESC', () {
        var instance = renderAttachedToDocument(FabToolbar()());
        FabToolbarComponent dartInstance = getDartComponent(instance);

        expect(dartInstance.state.isOpen, isFalse);

        dartInstance.open();

        expect(dartInstance.state.isOpen, isTrue);

        mockDocumentKeyDown(KeyCode.ESC);

        expect(dartInstance.state.isOpen, isFalse);
      });
    });

    group('exposes public API method:', () {
      test('toggle', () {
        var instance = render(FabToolbar()());
        FabToolbarComponent dartInstance = getDartComponent(instance);

        expect(dartInstance.state.isOpen, isFalse);

        dartInstance.toggle();

        expect(dartInstance.state.isOpen, isTrue);

        dartInstance.toggle();

        expect(dartInstance.state.isOpen, isFalse);
      });

      test('close', () {
        var instance = render(FabToolbar()());
        FabToolbarComponent dartInstance = getDartComponent(instance);

        expect(dartInstance.state.isOpen, isFalse);

        dartInstance.open();

        expect(dartInstance.state.isOpen, isTrue);

        dartInstance.close();

        expect(dartInstance.state.isOpen, isFalse);
      });

      test('open', () {
        var instance = render(FabToolbar()());
        FabToolbarComponent dartInstance = getDartComponent(instance);

        expect(dartInstance.state.isOpen, isFalse);

        dartInstance.open();

        expect(dartInstance.state.isOpen, isTrue);
      });
    });
  });
}
