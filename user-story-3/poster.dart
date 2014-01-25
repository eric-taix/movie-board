library movie.poster;

import 'package:polymer/polymer.dart';

import 'models.dart';
import 'utils.dart';

@CustomTag('movie-poster')
class Poster extends PolymerElement {
  
  @published Movie movie = new Movie.sample();
  
  Poster.created() : super.created();
  
  bool get applyAuthorStyles => true;
  
  Function asStars = intToStars;
  Function compTo10 = complement(10);
  
}