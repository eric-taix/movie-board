import 'package:polymer/builder.dart';
        
main(args) {
  build(entryPoints: ['web/task_board.html'], options: parseOptions(['--deploy']));
}
