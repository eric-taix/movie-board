library app_bootstrap;

import 'package:polymer/polymer.dart';

import 'ui/movie.dart' as i0;
import 'ui/movies.dart' as i1;
import 'task_board.html.0.dart' as i2;

void main() {
  configureForDeployment([
      'ui/movie.dart',
      'ui/movies.dart',
      'task_board.html.0.dart',
    ]);
  i2.main();
}
