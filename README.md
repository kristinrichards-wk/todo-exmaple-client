# Todo Example Client Application

## Installation
```
git clone git@github.com:Workiva/todo-example-client.git
```

## Building
```
pub get
```

## Serving
```
pub serve
```

Open [http://localhost:8080](http://localhost:8080).

## Development

### Formatting:

Use [dartfmt](https://github.com/dart-lang/dart_style) via [dart_dev](https://github.com/Workiva/dart_dev#supported-tasks) for general formatting, as well as [over_commafy](https://github.com/greglittlefield-wf/git_playground/tree/over_commafy/master#over_commafy) to maximize component readability.

1. [Install over_commafy](https://github.com/greglittlefield-wf/git_playground/tree/over_commafy/master#installation)
2. Format your code, either:
    - directly:
        ```bash
        over_commafy . && pub run dart_dev format
        ```
    
    - via an alias, for convenience:
        ```bash
        alias dfmt='over_commafy . && pub run dart_dev format'

        dfmt
        ```
