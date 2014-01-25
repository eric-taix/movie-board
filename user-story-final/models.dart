library movie_board.models;

import 'dart:convert';
import 'dart:html';

import 'package:polymer/polymer.dart';
import 'services.dart';



/// A storage to save movie's local datas
class MovieStorage {

  bool favorite;
  String comment;
  int _movieId;

  MovieStorage.fromLocalStorage(this._movieId) {
    try {
      String data = window.localStorage["${_movieId}"];
      Map map = JSON.decode(data);
      favorite = map['fav'] != null ? map['fav'] : false;
      comment = map['comment'] != null ? map['comment'] : "";
    }
    catch(e) {
      favorite = false;
      comment = "";
    }
  }

  /// Save current values to the local storage
  save() => window.localStorage["${_movieId}"] = '{ "fav" : ${favorite}, "comment" : "${comment}" }';
}

/// A movie with no detail
class Movie extends Observable {

  // Available comparators
  static final Map _comparators = {
    "title": (Movie a, Movie b) => a.title.compareTo(b.title),
    "vote": (Movie a, Movie b) => a.voteAverage.compareTo(b.voteAverage) * -1,
    "favorite": (Movie a, Movie b) => a.favorite && !b.favorite ? -1 : b.favorite && !a.favorite ? 1 : 0,
  };

  @observable int id;
  @observable String tag;
  @observable String title;
  @observable String posterPath;
  @observable String releasedDate;
  @observable int voteAverage;
  @observable int voteCount;
  @observable bool favorite ;
  @observable String comment;

  MovieStorage _storage;

  Movie(this.title, this.posterPath);

  Movie.sample() {
    id = 1;
    title = "Dart Flight School";
    posterPath = "../common/img/dart-flight-school.jpg";
    releasedDate="2014/02/19";
    voteAverage = 10;
    voteCount = 80;
  }

  Movie.fromMap(Map<String, Object> map) {
    id = map['id'];
    tag = map['tag'];
    title = map['title'] != null ? map['title'] : map['original_name'];
    posterPath = map['poster_path'] != null ? '../common/json/images/posters${map['poster_path']}' : '../common/img/no-poster-w130.jpg';
    releasedDate = map['release_date'];
    voteAverage = map['vote_average'] != null ? (map['vote_average'] as num).toInt() : 0;
    voteCount = map['vote_count'];

    // Load favorite and comment attributes from local storage
    _storage = new MovieStorage.fromLocalStorage(id);
    favorite = _storage.favorite;
    comment = _storage.comment;
    changes.listen((List<ChangeRecord> record) {
      record.forEach((PropertyChangeRecord propertyRecord) {
        if (propertyRecord.name == const Symbol('comment')) {
          _storage.comment = propertyRecord.newValue;
        }
        if (propertyRecord.name == const Symbol('favorite')) {
          _storage.favorite = propertyRecord.newValue;
        }
        _storage.save();
      });
    });
  }

  /// Get a comparator according to a field: if it does not exist then all movies are equals
  static getComparator(String field) => _comparators.containsKey(field) ? _comparators[field] : (a, b) => 0;

  /// Hashcode relies on movie's id
  int get hashCode => id;
  /// Equals relies also on movies's id
  bool operator ==(Movie other) => other != null ? id == other.id : false;
}

/// A movie with more details
class MovieDetail extends Movie with Observable {
  @observable String genre;
  @observable String tagLine;
  @observable String overview;
  @observable String productionCountry;
  @observable String trailer;
  @observable String country;


  /// String.isNotEmpty is removed from tree shaking, so used a getter instead
  @reflectable bool get hasTrailer => trailer != null ? trailer.isNotEmpty : false;

  MovieDetail.fromMap(Map<String, Object> map) : super.fromMap(map) {
    genre = map['genres'] != null && (map['genres'] as List).isNotEmpty ? (map['genres'] as List)[0]['name'] : '';
    tagLine = map['tagline']!= null && (map['tagline'] as String).isNotEmpty ? "\"${map['tagline']}\"" : "";
    overview = map['overview'];
    productionCountry = map['production_countries'] != null && (map['production_countries'] as List).isNotEmpty ? (map['production_countries'] as List)[0]['name'] : "";
    List trailers = map['trailers'] != null ? ((map['trailers'] as Map)['youtube'] as List) : [];
    trailer = trailers.isNotEmpty? ((map['trailers'] as Map)['youtube'] as List)[0]['source'] : '';
    country = map['production_countries'] != null && (map['production_countries'] as List).isNotEmpty ? ((map['production_countries'] as List)[0] as Map)['name'] : "";
  }
}

/// A menu
class Menu extends Object with Observable {

  @observable int id;
  @observable String name;
  @observable bool selected = false;
  MoviesRetriever retriever;

  Menu(this.id, this.name, this.retriever, [this.selected = false]);
  Menu.fromMap(Map<String, Object> map) {
    id = map['id'];
    name = map['name'];
  }
}