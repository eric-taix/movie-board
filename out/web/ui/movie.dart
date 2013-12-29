//  

import 'dart:html';
import 'package:polymer/polymer.dart';
import '../models.dart';

/**
 * A movie's poster UI component
 */
@CustomTag("j-movie")
class MoviePosterUI extends PolymerElement with ChangeNotifier  {
  
  @reflectable @published Movie get movie => __$movie; Movie __$movie = new Movie.sample(); @reflectable set movie(Movie value) { __$movie = notifyPropertyChange(#movie, __$movie, value); }
  @reflectable @observable bool get over => __$over; bool __$over = false; @reflectable set over(bool value) { __$over = notifyPropertyChange(#over, __$over, value); }
  
  MoviePosterUI.created() : super.created();
  
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

