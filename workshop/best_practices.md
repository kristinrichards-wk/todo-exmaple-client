# Web Skin Dart / OverReact Best Practices

> Best practices for writing Web Skin Dart / OverReact components


+ __[Prefer using variadic children](#prefer-using-variadic-children-instead-of-keyed-lists)__
+ __[Do break up render methods](#do-break-up-your-render-method-into-helper-methods-when-applicable)__
+ __[Do use helper methods for pre-configured components](#do-use-helper-methods-for-pre-configured-components)__
+ __[Do short circuit at the beginning of methods](#do-short-circuit-at-the-beginning-of-methods)__
+ __[Do group related props together](#do-group-related-props-together)__
+ __[Do put ref, key, and addTestId last](#do-put-ref-key-and-addtestid-last)__

## __PREFER__ using variadic children instead of keyed lists.

- Variadic / inlined children are easier to read.
- Children can be null so setting a variable based on some condition is preferred to using inline ternary statements or conditionally adding children to a list.

  ```dart
  // GOOD
  Dom.div()(
    Dom.div()(),
    Dom.div()(),
    Dom.div()(),
  )
  ```

  ```dart
  // BAD
  Dom.div()([
    (Dom.div()..key = 1)(),
    (Dom.div()..key = 2)(),
    (Dom.div()..key = 3)(),
  ])
  ```

  ```dart
  // GOOD
  List children = renderChildren();

  Dom.div()(children)
  ```

  ```dart
  // GOOD
  var lastChild = someCondition ? Dom.div()() : null;

  Dom.div()(
    Dom.div()(),
    Dom.div()(),
    lastChild,
  )
  ```

  ```dart
  // GOOD
  Dom.div()(
    Dom.div()(),
    Dom.div()(),
    someCondition ? Dom.div()() : null,
  )
  ```

  ```dart
  // BAD
  Dom.div()(
    Dom.div()(),
    Dom.div()(),
    someCondition
        ? (Dom.div()..className = 'foo bar')(
            Dom.div()('hey I am a child'),
          )
        : Dom.span()('what in the whaaat?'),
    )
  ```

  ```dart
  // BAD
  var children = [
    (Dom.div()..key = 1)(),
    (Dom.div()..key = 2)(),
  ];

  if (someCondition) children.add((Dom.div()..key = 3)())

  Dom.div()(children)
  ```

## __DO__ break up your render method into helper methods when applicable.
- Protip: makes render() easy to grok.

  ```dart
  // GOOD
  render() {
    return Dom.div()(
      renderFirstItem(),
      renderSecondItem(),
      renderThirdItem(),
    );
  }

  ReactElement renderFirstItem() {
    if (!shouldRenderFirstItem) return null;

    var classes = new ClassNameBuilder()
      ..add('foo');

    return (Dom.div()..classes = classes.toClassName())()
  }

  ReactElement renderSecondItem() {
    if (!shouldRenderSecondItem) return null;

    var classes = new ClassNameBuilder()
      ..add('bar');

    return (Dom.div()..classes = classes.toClassName())()
  }

  ReactElement renderThirdItem() {
    if (!shouldRenderThirdItem) return null;

    var classes = new ClassNameBuilder()
      ..add('baz');

    return (Dom.div()..classes = classes.toClassName())()
  }
  ```

  ```dart
  /// BAD
  render() {
    var firstItem;
    var secondItem;
    var thirdItem;

    if (shouldRenderFirstItem) {
      var classes = new ClassNameBuilder()
        ..add('foo');

      firstItem = (Dom.div()..classes = classes.toClassName())()
    }

    if (shouldRenderSecondItem) {
      var classes = new ClassNameBuilder()
        ..add('bar');

      secondItem = (Dom.div()..classes = classes.toClassName())()
    }

    if (shouldRenderThirdItem) {
      var classes = new ClassNameBuilder()
        ..add('baz');

      thirdItem = (Dom.div()..classes = classes.toClassName())()
    }

    return Dom.div()(
      firstItem,
      secondItem,
      thirdItem,
    );
  }
  ```

## __DO__ use helper methods for pre-configured components.
- Every component layer adds a performance hit (which we're actively working on minimizing), and also increases the complexity of your code.

  ```dart
  // GOOD
  BlockProps collapsedBlocked() => (Block()
    ..collapse = BlockCollapse.ALL
  );
  ```

  ```dart
  // BAD
  @Factory()
  UiFactory<CollapsedBlockProps> CollapsedBlock;

  @Props()
  class CollapsedBlockProps extends BlockProps {}

  @Component()
  class CollapsedBlockComponent extends UiComponent<CollapsedBlockProps> {
    @override
    render() {
      return (Block()
        ..addProps(copyUnconsumedProps())
        ..collapse = BlockCollapse.ALL
      )(props.children)
    }
  }
  ```

## __DO__ short circuit at the beginning of methods.
- Having methods short-circuit at the beginning makes it really clear what is happening.

  ```dart
  // GOOD
  ReactElement renderSomething() {
    if (someCondition) return null;

    var classes = new ClassNameBuilder()
      ..add('foo')
      ..add('bar');

    return (Dom.div()
      ..className = classes.toClassName()
      ..tabIndex = -1
    )();
  }
  ```

  ```dart
  // BAD
  ReactElement renderSomething() {
    var classes = new ClassNameBuilder()
      ..add('foo')
      ..add('bar');

    return someCondition
        ? null
        : (Dom.div()
            ..className = classes.toClassName()
            ..tabIndex = -1
          )();
  }
  ```

## __DO__ group related props together.
- This makes it easier to grok what props are set and will help not setting duplicate props.

  ```dart
  // GOOD
  (Dom.div()
    ..onChange = (_) { ... }
    ..onMouseDown = (_) { ... }
    ..onFocus = (_) { ... }
    ..tabIndex = -1
    ..title = 'Browser title'
  )()
  ```

  ```dart
  // BAD
  (Dom.div()
    ..onMouseDown = (_) { ... }
    ..title = 'Browser title'
    ..onFocus = (_) { ... }
    ..tabIndex = -1
    ..onChange = (_) { ... }
  )()
  ```

## __DO__ put `ref`, `key`, and `addTestId` last.
- It's a good idea to have a consistent order / placement for these non-DOM props, makes it easier to grok what is applied.

  ```dart
  // GOOD
  (Dom.div()
    ..tabIndex = -1
    ..onChange = (_) { ... }
    ..ref = (ref) {
      this._ref = ref;
    }
    ..key = 1
    ..addTestId('testId')
  )()
  ```

  ```dart
  // BAD
  (Dom.div()
    ..ref = (ref) {
      this._ref = ref;
    }
    ..tabIndex = -1
    ..addTestId('testId')
    ..onChange = (_) { ... }
    ..key = 1
  )()
  ```
