library movie_board.models;

/**
 * A movie model
 */
class Movie {
  
  int id;
  String title;
  String posterPath;
  String backdropPath;
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
    posterPath = 'json/images/posters${map['poster_path']}';
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
class Menu {
  
  int id;
  String name;
  
  Menu(this.id, this.name);
  Menu.fromMap(Map<String, Object> map) {
    id = map['id'];
    name = map['name'];
  }
}