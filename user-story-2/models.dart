
import 'package:polymer/polymer.dart';

class Movie {
  @reflectable int id;
  @reflectable String title;
  @reflectable String posterPath;
  @reflectable String releasedDate;
  @reflectable int voteAverage;
  @reflectable int voteCount;
  @reflectable bool favorite;
  String tag;
  
  Movie.sample() {
    id = 1;
    title = "Eric Taix";
    posterPath = "../common/img/dart-flight-school.jpg";
    releasedDate="2014/02/19";
    voteAverage = 1;
    voteCount = 8000;
    tag = "now_playing";
  }
  
  Movie.fromJSON(Map<String, Object> json) {
    id=json['id'];
    title=json['title'];
    posterPath=json['poster_path'] != null ? "../common/json/images/posters${json['poster_path']}" : "../common/img/no-poster-w130.jpg";
    releasedDate=json['release_date'];
    voteAverage=(json['vote_average'] as num).toInt();
    voteCount=json['vote_count'];
    tag=json['tag'];
  }
}