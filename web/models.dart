library movies.models;

/**
 * A movie model
 */
class Movie {
  
  String title;
  String posterPath;
  bool featured = true;
  int genre;
  
  Movie(this.title, this.posterPath, {bool featured : false}) : this.featured = featured;
  
  Movie.sample() : this("Hunger Games", "img/hgl.jpg");
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