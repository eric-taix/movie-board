library movie_board.movie_poster;

import 'package:polymer/polymer.dart';

import 'dart:html';
import '../models.dart';

/**
 * A movie's poster UI component
 */
@CustomTag("movie-poster")
class Poster extends PolymerElement {
  
  @published Movie movie = new Movie.sample();
  @observable bool over = false;
  
  Poster.created() : super.created();
  
  /// Apply styles which are defined outside the component
  bool get applyAuthorStyles => true;
  
  /// Utility function which generates stars
  String stars(int rating) => new List.generate(rating, (_) => "\u2605").join();
  
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

