library movie_board.models;

import 'package:polymer/polymer.dart';
import 'services.dart';

/**
 * A movie model
 */
class Movie extends Object with Observable {
  
  int id;
  String title;
  String posterPath;
  String backdropPath;
  String releasedDate;
  num popularity;
  int voteAverage;
  int voteCount;
  @observable bool favorite = false;
  
  Movie(this.title, this.posterPath, {bool featured : false});
  
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