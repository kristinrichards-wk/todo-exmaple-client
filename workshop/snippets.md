# Web Skin Dart / OverReact snippets

> Snippets for writing and testing Web Skin Dart / OverReact components.

+ __[Stateless Component](#stateless-component)__
+ __[Stateful Component](#stateful-component)__
+ __[Abstract Stateless Component](#asbtract-stateless-component)__
+ __[Abstract Stateful Component](#asbtract-stateful-component)__
+ __[Prop Mixin](#prop-mixin)__
+ __[Class Name and Prop Forwarding](#class-name-and-prop-forwarding)__
+ __[Testing](#testing)__

## Stateless Component

```dart
@Factory()
UiFactory<$1Props> $1;

@Props()
class $1Props extends UiProps {

}

@Component()
class $1Component extends UiComponent<$1Props> {
  @override
  Map getDefaultProps() => (newProps());

  @override
  render() {

  }
}
```

## Stateful Component

```dart
@Factory()
UiFactory<$1Props> $1;

@Props()
class $1Props extends UiProps {

}

@State()
class $1State extends UiState {

}

@Component()
class $1Component extends UiStatefulComponent<$1Props, $1State> {
  @override
  Map getDefaultProps() => (newProps());

  @override
  Map getInitialState() => (newState());

  @override
  render() {}
}
```

## Abstract Stateless Component

```dart
@AbstractProps()
abstract class $1Props extends UiProps {

}

@AbstractComponent()
abstract class $1Component<T extends $1Props> extends UiComponent<T> {
  @override
  Map getDefaultProps() => (newProps());

  @override
  render() {

  }
}
```

## Abstract Stateful Component

```dart
@AbstractProps()
abstract class $1Props extends UiProps {

}

@AbstractState()
abstract class $1State extends UiState {

}

@AbstractComponent()
abstract class $1Component<T extends $1Props, S extends $1State> extends UiStatefulComponent<T, S> {
  @override
  Map getDefaultProps() => (newProps());

  @override
  Map getInitialState() => (newState());

  @override
  render() {

  }
}
```

## Props Mixin

```dart
@PropsMixin()
abstract class $1PropsMixin {
  static final $1PropsMixinMapView defaultProps = new $1PropsMixinMapView({});

  Map get props;
}

class $1PropsMixinMapView extends MapView with $1PropsMixin {
  /// The props to be manipulated via the getters/setters.
  /// In this case, it's the current MapView object.
  @override
  Map get props => this;
}
```

## Class Name and Prop Forwarding

```dart
@override
render() {
  var classes = forwardingClassNameBuilder()
    ..add('foo-bar');

  return (Dom.div()
    ..addProps(copyUnconsumedProps())
    ..className = classes.toClassName()
  )();
}
```

## Testing

```dart
test('$1', () {

});
```

```dart
group('$1', () {

});
```
