library movie_board.movie_poster;

import 'package:polymer/polymer.dart';

import '../models.dart';

/**
 * A movie's poster UI component
 */
@CustomTag("movie-poster")
class Poster extends PolymerElement {
  
  @published Movie movie;
  
  Poster.created() : super.created();
  
  // Apply styles which are defined outside the component
  bool get applyAuthorStyles => true;
  
  // Utility function which generates stars
  String stars(int rating) => new List.generate(rating, (_) => "\u2605").join();
  
}

