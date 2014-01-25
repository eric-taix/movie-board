library movies.poster;

import 'dart:html';
import 'package:polymer/polymer.dart';

import 'models.dart';
import 'utils.dart';

@CustomTag("movie-poster")
class Poster extends PolymerElement {

  @published Movie movie;

  Poster.created() : super.created();

  /// Apply styles which are defined outside the component
  bool get applyAuthorStyles => true;

  /// Filter which generates stars
  Function asStars = intToStars();
  /// Filter which generatee the selected class
  Function asFavoriteClass = selectedToClass('favorite');

  /// Flip (true <--> false) the movie's favorite attribute
  flipFavorite(Event e, var detail, Element target) => dispatchEvent(new CustomEvent('updatefavorite', detail: movie ..favorite = !movie.favorite));

  /// Show the detail of the current movie
  showDetail(Event e, var detail, Element target) => window.location.href = "#/movies/${movie.id}";
}

