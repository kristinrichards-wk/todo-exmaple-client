library tool.dev;

import 'package:dart_dev/dart_dev.dart' show TestRunnerConfig, config, dev;

main(List<String> args) async {
  // https://github.com/Workiva/dart_dev

  var directories = ['lib/', 'tool/', 'web/'];
  config.analyze.entryPoints = directories;
  config.format
    ..directories = directories
    ..lineLength = 100;

  config.genTestRunner.configs = [
    new TestRunnerConfig(
        genHtml: true,
        directory: 'test/unit',
        filename: 'generated_runner_test',
        dartHeaders: const [
          "import 'package:react/react_client.dart';",
          "import 'package:web_skin_dart/ui_core.dart';"
        ],
        preTestCommands: const [
          'setClientConfiguration();',
          'enableTestMode();'
        ],
        htmlHeaders: const [
          '<script src="packages/web_skin/dist/js/core/modernizr/modernizr-custom.js"></script>',
          '<script src="packages/react/react_with_addons.js"></script>',
          '<script src="packages/react/react_dom.js"></script>'
        ])
  ];
  config.test
    ..platforms = ['content-shell']
    ..pubServe = true
    ..unitTests = ['test/unit/generated_runner_test.dart'];

  config.taskRunner.tasksToRun = [
    'pub run dart_dev format --check',
    'pub run dart_dev analyze',
    'pub run dart_dev gen-test-runner --check',
    'pub run dart_dev test'
  ];

  await dev(args);
}
