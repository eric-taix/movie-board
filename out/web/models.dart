library movies.models;

/**
 * A movie model
 */
class Movie {
  
  int id;
  String title;
  String posterPath;
  String releasedDate;
  num popularity;
  int voteAverage;
  int voteCount;
  
  int genre;

  
  Movie.sample() : this("Hunger Games", "img/hgl.jpg");

  Movie(this.title, this.posterPath, {bool featured : false});
  
  Movie.fromMap(Map<String, Object> map) {
    id = map['id'];
    title = map['title'];
    posterPath = 'json/images${map['poster_path']}';
    releasedDate = map['release_date'];
    popularity = map['popularity'];
    voteAverage = (map['vote_average'] as num).toInt();
    voteCount = map['vote_count'];
  }
  
}

/**
 * A genre of movie
 */
class Genre {
  
  int id;
  String name;
  
  Genre(this.id, this.name);
  Genre.fromMap(Map<String, Object> map) {
    id = map['id'];
    name = map['name'];
  }
}