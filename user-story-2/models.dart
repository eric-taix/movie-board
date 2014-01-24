
import 'package:polymer/polymer.dart';

class Movie extends Observable {
  @observable int id;
  @observable String title;
  @observable String posterPath;
  @observable String releasedDate;
  @observable int voteAverage;
  @observable int voteCount;
  
  Movie.sample() {
    id = 1;
    title = "Eric Taix";
    posterPath = "img/dart-flight-school.jpg";
    releasedDate="2014/02/19";
    voteAverage = 1;
    voteCount = 8000;
  }
  Movie.fromJSON(Map<String, Object> json) {
    id=json['id'];
    title=json['title'];
    posterPath=json['poster_path'];
    releasedDate=json['release_date'];
    voteAverage=json['vote_average'];
    voteCount=json['vote_count'];
  }
}