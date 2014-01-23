library movies.dialog;

import 'dart:html';
import 'package:polymer/polymer.dart';

@CustomTag('movie-dialog')
class Dialog extends PolymerElement {
  
  bool get applyAuthorStyles => true;
  
  Dialog.created() : super.created();
  
  /// The user clicks the close button
  close(Event e, var detail, Element target) {
    dispatchEvent(new CustomEvent('close'));
  }
}
