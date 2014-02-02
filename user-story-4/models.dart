
import 'dart:html';
import 'dart:convert';

import 'package:polymer/polymer.dart';

class Movie extends Observable {
  
  static final Map _comparators = {
    "default": (Movie a, Movie b) => 0,
    "title": (Movie a, Movie b) => a.title.compareTo(b.title),
    "vote": (Movie a, Movie b) => a.voteAverage.compareTo(b.voteAverage) * -1,
    "favorite": (Movie a, Movie b) => a.favorite && !b.favorite ? -1 : b.favorite && !a.favorite ? 1 : 0,
  };
  
  /// Returns comparator according to the field's name or the default comparator if it does not exist
  static getComparator(String field) => _comparators.containsKey(field) ? _comparators[field] : _comparators['default'];
  
  @observable int id;
  @observable String title;
  @observable String posterPath;
  @observable String releasedDate;
  @observable int voteAverage;
  @observable int voteCount;
  @observable String tag;
  @observable bool favorite = false;
  
  Movie.sample() {
    id = 1;
    title = "Eric Taix";
    posterPath = "../common/img/dart-flight-school.jpg";
    releasedDate="2014/02/19";
    voteAverage = 1;
    voteCount = 8000;
  }
  
  Movie.fromJSON(Map<String, Object> json) {
    id=json['id'];
    title=json['title'];
    posterPath=json['poster_path'] != null ? "../common/json/images/posters${json['poster_path']}" : "../common/img/no-poster-w130.jpg";
    releasedDate=json['release_date'];
    voteAverage=(json['vote_average'] as num).toInt();
    voteCount=json['vote_count'];
    tag=json['tag'];
    
    favorite = false;
    try {
      String data = window.localStorage["${id}"];
      if (data != null) {
        favorite = JSON.decode(data)["fav"];
      }
    }
    catch(e) {
      print(e);
    }
    new PathObserver(this, 'favorite').changes.listen((records) {
      window.localStorage["${id}"] = '{ "fav" : ${records[0].newValue} }';
    });

  }
}