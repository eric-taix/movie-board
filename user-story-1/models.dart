library movie.models;

import 'package:polymer/polymer.dart';

class Movie extends Observable {
  @observable int id;
  @observable String title;
  @observable String posterPath;
  @observable String releasedDate;
  @observable int voteAverage;
  @observable int voteCount;
  @observable bool favorite;
  
  Movie.sample() {
    id = 1;
    title = "Eric Taix";
    posterPath = "../common/img/dart-flight-school.jpg";
    releasedDate="2014/02/19";
    voteAverage = 1;
    voteCount = 8000;
  }
}