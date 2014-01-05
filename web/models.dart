library movie_board.models;

import 'package:polymer/polymer.dart';
import 'services.dart';

/**
 * A movie model
 */
class Movie extends Object with Observable {
  
  // Available comparators
  static final Map _comparators = {
    "title": (Movie a, Movie b) => a.title.compareTo(b.title),
    "vote": (Movie a, Movie b) => a.voteAverage.compareTo(b.voteAverage) * -1,
    "favorite": (Movie a, Movie b) => a.favorite && !b.favorite ? -1 : b.favorite && !a.favorite ? 1 : 0,
  };
  
  int id;
  String title;
  String posterPath;
  String backdropPath;
  String releasedDate;
  num popularity;
  int voteAverage;
  int voteCount;
  @observable bool favorite = false;
  
  Movie(this.title, this.posterPath);
  
  Movie.fromMap(Map<String, Object> map) {
    id = map['id'];
    title = map['title'] != null ? map['title'] : map['original_name'];
    posterPath = map['poster_path'] != null ? 'json/images/posters${map['poster_path']}' : 'img/no-poster-w130.jpg';
    backdropPath = 'json/images/backdrops${map['backdrop_path']}';
    releasedDate = map['release_date'];
    popularity = map['popularity'];
    voteAverage = (map['vote_average'] as num).toInt();
    voteCount = map['vote_count'];
  }
  
  /// Get a comparator according to a field: if it does not exist then all movies are equals
  static getComparator(String field) => _comparators.containsKey(field) ? _comparators[field] : (a, b) => 0;

}

/**
 * Movies menu
 */
  class Menu extends Object with Observable {
  
  int id;
  @observable String name;
  bool selected = false;
  MoviesRetriever retriever;
  
  Menu(this.id, this.name, this.retriever, [this.selected = false]);
  Menu.fromMap(Map<String, Object> map) {
    id = map['id'];
    name = map['name'];
  }
}