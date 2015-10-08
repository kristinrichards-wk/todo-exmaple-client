library tool.dev;

import 'package:dart_dev/dart_dev.dart' show dev, config;

main(List<String> args) async {
  // https://github.com/Workiva/dart_dev

  var directories = ['lib/', 'tool/', 'web'];
  config.analyze.entryPoints = directories;
  config.format.directories = directories;
  config.test.unitTests = [];

  await dev(args);
}
