// 360c015ba3d57c3c624687c111f91c27

import 'dart:html';
import 'package:polymer/polymer.dart';
import '../models.dart';

/**
 * A movie's poster UI component
 */
@CustomTag("j-movie")
class MoviePosterUI extends PolymerElement {
  
  @published Movie movie = new Movie.sample();
  @observable bool over = false;
  
  MoviePosterUI.created() : super.created();
  
  /**
   * The mouse is over the poster
   */
  onOver(Event e, var detail, Node target) {
    over = true;
    dispatchEvent(new CustomEvent('posterover', detail: this));
  }
  
  /**
   * The mouse is out the poster
   */
  onOut(Event e, var detail, Node target) => over = false;
}

