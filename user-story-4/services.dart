library movie.services;

import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'models.dart';

final MovieService moviesService = new MovieService();

/// Service definition
abstract class MovieService {
  
  factory MovieService() => new HttpMovieService();
  
  Future<List<Movie>> getAllMovies();
  
  Future<List<Movie>> getMovies(String tag);
  
  Future<List<Movie>> getFavorites();
  
}

/// In memory service implementation
class InMemoryMovieService implements MovieService {
  
  List<Movie> _movies;
  
  InMemoryMovieService() {
    _movies = JSON.decode(IN_MEMORY_JSON).map((Map map) => new Movie.fromJSON(map)).toList();
  }
  
  Future<List<Movie>> getAllMovies() => new Future(() => _movies);

  Future<List<Movie>> getMovies(String tag) => new Future(() => _movies.where((Movie m ) => m.tag == tag).toList());
  
  Future<List<Movie>> getFavorites() => new Future(() => _movies.where((Movie m) => m.favorite).toList());
}

/// HTTP service implementation
class HttpMovieService implements MovieService {
  
  List<Movie> _movies;

  Future<List<Movie>> getAllMovies() {
    if (_movies == null) {
      Completer completer = new Completer();
      HttpRequest.getString('../common/json/all.json').then(JSON.decode).then((List ms) {
        _movies = ms.map((Map map) => new Movie.fromJSON(map)).toList();
        completer.complete(_movies);
      });
      return completer.future;
    }
    else {
      return new Future(() => _movies);
    }
  }
  
  Future<List<Movie>> getMovies(String tag) => new Future(() => _movies.where((Movie m ) => m.tag == tag).toList());
  
  Future<List<Movie>> getFavorites() => new Future(() => _movies.where((Movie m) => m.favorite).toList());
}

/// HTTP response simulation
const String IN_MEMORY_JSON = '''
[
  {
  "tag":"upcoming","adult": false,
  "id": 180894,
  "original_title": "Ninja: Shadow of a Tear",
  "release_date": "2013-12-31",
  "poster_path": "/wkyQMLLh7DQBjU1a3J3oY01mFwv.jpg",
  "popularity": 7.45421723203125,
  "title": "Ninja: Shadow of a Tear",
  "vote_average": 7,
  "vote_count": 4
  },
  {
  "tag":"upcoming","adult": false,
  "id": 245589,
  "original_title": "Voodoo Possession",
  "release_date": "2014-01-14",
  "poster_path": "/pJKEFRDKH24ahbkuEQgcFT6rDiH.jpg",
  "popularity": 6.087,
  "title": "Voodoo Possession",
  "vote_average": 0,
  "vote_count": 0
  },
  {
  "tag":"upcoming","adult": false,
  "id": 188207,
  "original_title": "The Legend of Hercules",
  "release_date": "2014-01-10",
  "poster_path": "/lAW2TKVI1W2SksalbEJgCJS7nWq.jpg",
  "popularity": 5.17426356194849,
  "title": "The Legend of Hercules",
  "vote_average": 10,
  "vote_count": 1
  },
  {
  "tag":"upcoming","adult": false,
  "id": 137094,
  "original_title": "Jack Ryan: Shadow Recruit",
  "release_date": "2014-01-17",
  "poster_path": "/jJBiGr1ghzZ9vNAW7fb2P7HLGy5.jpg",
  "popularity": 5.09945584355446,
  "title": "The Ryan Initiative",
  "vote_average": 0,
  "vote_count": 0
  },
  {
  "tag":"upcoming","adult": false,
  "id": 227359,
  "original_title": "Force of Execution",
  "release_date": "2013-12-31",
  "poster_path": "/xtYgNW35GOzCJz35SMg5OjAmMwd.jpg",
  "popularity": 3.58056646624641,
  "title": "Force of Execution",
  "vote_average": 7.5,
  "vote_count": 4
  },
  {
  "tag":"upcoming","adult": false,
  "id": 214140,
  "original_title": "McCanick",
  "release_date": "2013-12-31",
  "poster_path": "/i3QnkHoNIfAxPVZ9UCU0NBu0s5Z.jpg",
  "popularity": 2.67877401989222,
  "title": "McCanick",
  "vote_average": 5.8,
  "vote_count": 2
  },
  {
  "tag":"upcoming","adult": false,
  "id": 202220,
  "original_title": "不二神探",
  "release_date": "2013-12-31",
  "poster_path": "/bXd9v2fSVZih0frr2kv2Mt1LBHq.jpg",
  "popularity": 2.65695,
  "title": "不二神探",
  "vote_average": 5.1,
  "vote_count": 16
  },
  {
  "tag":"upcoming","adult": false,
  "id": 193756,
  "original_title": "Lone Survivor",
  "release_date": "2014-01-10",
  "poster_path": "/dH3wAmsPZtHzA8uYngWvJkOlPWo.jpg",
  "popularity": 2.56101622887163,
  "title": "Du Sang et des larmes",
  "vote_average": 4.8,
  "vote_count": 2
  },
  {
  "tag":"upcoming","adult": false,
  "id": 244534,
  "original_title": "Happy Christmas",
  "release_date": "2014-01-19",
  "poster_path": "/iJhUtO9mIgELALNcpDJlGrrgm4u.jpg",
  "popularity": 2.175,
  "title": "Happy Christmas",
  "vote_average": 0,
  "vote_count": 0
  },
  {
  "tag":"upcoming","adult": false,
  "id": 246013,
  "original_title": "War Story",
  "release_date": "2014-01-19",
  "poster_path": null,
  "popularity": 2.14,
  "title": "War Story",
  "vote_average": 0,
  "vote_count": 0
  },
  {
  "tag":"upcoming","adult": false,
  "id": 168530,
  "original_title": "Ride Along",
  "release_date": "2014-01-17",
  "poster_path": "/avWkbgz4vFbW2aqAT1kjc7e6kHy.jpg",
  "popularity": 2.020642693595,
  "title": "Ride Along",
  "vote_average": 0,
  "vote_count": 0
  },
  {
  "tag":"upcoming","adult": false,
  "id": 227348,
  "original_title": "Paranormal Activity: The Marked Ones",
  "release_date": "2014-01-03",
  "poster_path": "/j8oJPNALJ7z3ZvEGk9Cm32nN6qP.jpg",
  "popularity": 1.9941664675,
  "title": "Paranormal Activity: The Marked Ones",
  "vote_average": 0,
  "vote_count": 0
  },
  {
  "tag":"upcoming","adult": false,
  "id": 244786,
  "original_title": "Whiplash",
  "release_date": "2014-01-16",
  "poster_path": null,
  "popularity": 1.92,
  "title": "Whiplash",
  "vote_average": 0,
  "vote_count": 0
  },
  {
  "tag":"upcoming","adult": false,
  "id": 244772,
  "original_title": "The Skeleton Twins",
  "release_date": "2014-01-18",
  "poster_path": "/uL99L4I3hp5hoN32sL6x8gT2L80.jpg",
  "popularity": 1.895,
  "title": "The Skeleton Twins",
  "vote_average": 0,
  "vote_count": 0
  },
  {
  "tag":"upcoming","adult": false,
  "id": 106136,
  "original_title": "Chasing Shakespeare",
  "release_date": "2014-01-01",
  "poster_path": "/tUNw99RU2p8CgryxZJXsMgAxzqK.jpg",
  "popularity": 1.7772325436145,
  "title": "Chasing Shakespeare",
  "vote_average": 9.5,
  "vote_count": 1
  },
  {
  "tag":"upcoming","adult": false,
  "id": 245775,
  "original_title": "Yves Saint Laurent",
  "release_date": "2014-01-08",
  "poster_path": "/jcc93G88KDifmArGBW61GcgSwMR.jpg",
  "popularity": 1.743,
  "title": "Yves Saint Laurent",
  "vote_average": 0,
  "vote_count": 0
  },
  {
  "tag":"upcoming","adult": false,
  "id": 8947,
  "original_title": "Dirty Tricks",
  "release_date": "2013-12-31",
  "poster_path": null,
  "popularity": 1.684049,
  "title": "Dirty Tricks",
  "vote_average": 0,
  "vote_count": 0
  },
  {
  "tag":"upcoming","adult": false,
  "id": 236426,
  "original_title": "Cleanin' Up the Town: Remembering Ghostbusters",
  "release_date": "2014-01-01",
  "poster_path": "/gyTR4KpbZbpmTv96aCO41uDZEjl.jpg",
  "popularity": 1.6782138159975,
  "title": "Cleanin' Up the Town: Remembering Ghostbusters",
  "vote_average": 0,
  "vote_count": 0
  },
  {
  "tag":"upcoming","adult": false,
  "id": 152751,
  "original_title": "33 días",
  "release_date": "2014-01-01",
  "poster_path": null,
  "popularity": 1.6614,
  "title": "33 días",
  "vote_average": 0,
  "vote_count": 0
  },
  {
  "tag":"upcoming","adult": false,
  "id": 127560,
  "original_title": "The Railway Man",
  "release_date": "2014-01-01",
  "poster_path": "/ZwuYvNgYrRivzjrDDyxtbKvlaO.jpg",
  "popularity": 1.598164,
  "title": "The Railway Man",
  "vote_average": 6,
  "vote_count": 1
  },
  {
  "tag": "now_playing","adult": false,
  "id": 57158,
  "original_title": "The Hobbit: The Desolation of Smaug",
  "release_date": "2013-12-13",
  "poster_path": "/ht6Epa4tgPH4B1dOE5FPcvx2PsN.jpg",
  "popularity": 125.349167842259,
  "title": "Hobbit (Le) : La Désolation de Smaug",
  "vote_average": 7.5,
  "vote_count": 182
  },
  {
  "tag": "now_playing","adult": false,
  "id": 172803,
  "original_title": "Hours",
  "release_date": "2013-12-12",
  "poster_path": "/8KEuqkOmxvtR4rLynkvBhpaNMfM.jpg",
  "popularity": 29.1697547560311,
  "title": "Hours",
  "vote_average": 7,
  "vote_count": 26
  },
  {
  "tag": "now_playing","adult": false,
  "id": 106646,
  "original_title": "The Wolf of Wall Street",
  "release_date": "2013-12-25",
  "poster_path": "/n6Wxjscd0iACcjKrNwy9DJDPmZH.jpg",
  "popularity": 26.5190702531363,
  "title": "Le Loup de Wall Street",
  "vote_average": 7,
  "vote_count": 12
  },
  {
  "tag": "now_playing","adult": false,
  "id": 168672,
  "original_title": "American Hustle",
  "release_date": "2013-12-18",
  "poster_path": "/2Aur1bxpCVzyTdWnGtxysInVlAT.jpg",
  "popularity": 26.3804227977273,
  "title": "American Bluff",
  "vote_average": 7.9,
  "vote_count": 21
  },
  {
  "tag": "now_playing","adult": false,
  "id": 230222,
  "original_title": "Tarzan",
  "release_date": "2013-12-18",
  "poster_path": "/eKyA4Npdn4QHujNUsT7KhDyOy8N.jpg",
  "popularity": 26.3480476265503,
  "title": "Tarzan",
  "vote_average": 7.8,
  "vote_count": 3
  },
  {
  "tag": "now_playing","adult": false,
  "id": 116745,
  "original_title": "The Secret Life of Walter Mitty",
  "release_date": "2013-12-25",
  "poster_path": "/dhc1TUJj1QQ8SGTkOcjJek9JKJy.jpg",
  "popularity": 24.3391846325328,
  "title": "La Vie rêvée de Walter Mitty",
  "vote_average": 6.9,
  "vote_count": 10
  },
  {
  "tag": "now_playing","adult": false,
  "id": 140823,
  "original_title": "Saving Mr. Banks",
  "release_date": "2013-12-20",
  "poster_path": "/aG33huZ8MJJNUsDrBK22cIuiuUM.jpg",
  "popularity": 23.4236670197698,
  "title": "Saving Mr. Banks",
  "vote_average": 8.5,
  "vote_count": 13
  },
  {
  "tag": "now_playing","adult": false,
  "id": 109443,
  "original_title": "Anchorman 2: The Legend Continues",
  "release_date": "2013-12-18",
  "poster_path": "/8HweezekJmUn4Rth0CoHa1pVKdC.jpg",
  "popularity": 18.5836968369797,
  "title": "Légendes vivantes",
  "vote_average": 6,
  "vote_count": 14
  },
  {
  "tag": "now_playing","adult": false,
  "id": 238589,
  "original_title": "Enemies Closer",
  "release_date": "2013-12-24",
  "poster_path": "/fijxg3K1RPpQvkPnjNAftTnW8Yl.jpg",
  "popularity": 11.625397113215,
  "title": "Enemies Closer",
  "vote_average": 5.6,
  "vote_count": 8
  },
  {
  "tag": "now_playing","adult": false,
  "id": 239530,
  "original_title": "Majokko Shimai no Yoyo to Nene",
  "release_date": "2013-12-28",
  "poster_path": null,
  "popularity": 10,
  "title": "Majokko Shimai no Yoyo to Nene",
  "vote_average": 0,
  "vote_count": 0
  },
  {
  "tag": "now_playing","adult": false,
  "id": 180894,
  "original_title": "Ninja: Shadow of a Tear",
  "release_date": "2013-12-31",
  "poster_path": "/wkyQMLLh7DQBjU1a3J3oY01mFwv.jpg",
  "popularity": 9.1473907734375,
  "title": "Ninja: Shadow of a Tear",
  "vote_average": 7,
  "vote_count": 4
  },
  {
  "tag": "now_playing","adult": false,
  "id": 64686,
  "original_title": "47 Ronin",
  "release_date": "2013-12-25",
  "poster_path": "/2otPirPWbW56rAydNOFh8AWrOwm.jpg",
  "popularity": 9.07773858007064,
  "title": "47 Ronin",
  "vote_average": 5.6,
  "vote_count": 10
  },
  {
  "tag": "now_playing","adult": false,
  "id": 239523,
  "original_title": "劇場版 HUNTERxHUNTER THE LAST MISSION",
  "release_date": "2013-12-27",
  "poster_path": "/rscp2M11FFyQNkkBn0pks9ukS6k.jpg",
  "popularity": 8.93,
  "title": "劇場版 HUNTERxHUNTER THE LAST MISSION",
  "vote_average": 0,
  "vote_count": 0
  },
  {
  "tag": "now_playing","adult": false,
  "id": 229405,
  "original_title": "Panic in the Mailroom",
  "release_date": "2013-12-10",
  "poster_path": "/5OqSdTuwFIZpmZL2dP4J7C64wAs.jpg",
  "popularity": 6.38943382449786,
  "title": "Moi, Moche et Méchant 2 : Panic in the Mailroom",
  "vote_average": 8.2,
  "vote_count": 10
  },
  {
  "tag": "now_playing","adult": false,
  "id": 243790,
  "original_title": "A Young Doctor's Notebook and Other Stories",
  "release_date": "2013-12-12",
  "poster_path": "/9h1TsQZNwtqHFHaxiTqbin7cMsc.jpg",
  "popularity": 6.08,
  "title": "A Young Doctor's Notebook and Other Stories",
  "vote_average": 10,
  "vote_count": 1
  },
  {
  "tag": "now_playing","adult": false,
  "id": 175555,
  "original_title": "Tyler Perry's A Madea Christmas",
  "release_date": "2013-12-13",
  "poster_path": "/d7pmaRFSqK3TJPXLUTxFA4feTub.jpg",
  "popularity": 5.98454609776599,
  "title": "Tyler Perry's A Madea Christmas",
  "vote_average": 4,
  "vote_count": 1
  },
  {
  "tag": "now_playing","adult": false,
  "id": 64807,
  "original_title": "Grudge Match",
  "release_date": "2013-12-25",
  "poster_path": "/8Gvfnqq9ipqMhsU8mJvvsOlU2AG.jpg",
  "popularity": 5.41189163342765,
  "title": "Match retour",
  "vote_average": 8,
  "vote_count": 1
  },
  {
  "tag": "now_playing","adult": false,
  "id": 44977,
  "original_title": "Dhoom 3",
  "release_date": "2013-12-20",
  "poster_path": "/yt0VgteKEi7sW0g9eb45mIiNx4g.jpg",
  "popularity": 4.9447699025625,
  "title": "Dhoom 3",
  "vote_average": 9,
  "vote_count": 4
  },
  {
  "tag": "now_playing","adult": false,
  "id": 111473,
  "original_title": "The Invisible Woman",
  "release_date": "2013-12-25",
  "poster_path": "/iziHFAZPMLH5LzKa2yyJxs4RJgY.jpg",
  "popularity": 4.6312,
  "title": "The Invisible Woman",
  "vote_average": 0,
  "vote_count": 0
  },
  {
  "tag": "now_playing","adult": false,
  "id": 227359,
  "original_title": "Force of Execution",
  "release_date": "2013-12-31",
  "poster_path": "/xtYgNW35GOzCJz35SMg5OjAmMwd.jpg",
  "popularity": 4.60188822082136,
  "title": "Force of Execution",
  "vote_average": 7.5,
  "vote_count": 4
  }]''';