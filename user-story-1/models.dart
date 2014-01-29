library movie.models;

import 'package:polymer/polymer.dart';

class Movie {
  @reflectable int id;
  @reflectable String title;
  @reflectable String posterPath;
  @reflectable String releasedDate;
  @reflectable int voteAverage;
  @reflectable int voteCount;
  @reflectable bool favorite;
  
  Movie.sample() {
    id = 1;
    title = "Eric Taix";
    posterPath = "../common/img/dart-flight-school.jpg";
    releasedDate="2014/02/19";
    voteAverage = 1;
    voteCount = 8000;
  }
}