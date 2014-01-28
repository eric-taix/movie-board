library movie.poster;

import 'dart:html';

import 'package:polymer/polymer.dart';

import 'models.dart';
import 'utils.dart';

@CustomTag('movie-poster')
class Poster extends PolymerElement {
  
  @published Movie movie = new Movie.sample();
  
  Poster.created() : super.created();
  
  bool get applyAuthorStyles => true;
  
  Function asStars = intToStars;
  Function complementTo10 = complement(10);
  Function asFavoriteClass = selectedToClass('favorite');
  
  flipFavorite(Event e, var detail, Element target) => dispatchEvent(new CustomEvent("movieupdated", detail: movie ..favorite = !movie.favorite));
}
