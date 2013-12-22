library app_bootstrap;

import 'package:polymer/polymer.dart';

import 'ui/movie.dart' as i0;
import 'ui/movies.dart' as i1;
import 'ui/genres.dart' as i2;
import 'task_board.html.0.dart' as i3;

void main() {
  configureForDeployment([
      'ui/movie.dart',
      'ui/movies.dart',
      'ui/genres.dart',
      'task_board.html.0.dart',
    ]);
  i3.main();
}
