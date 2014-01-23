library movie.utils;

Function intToStars = (int nb) => new List.generate(nb, (_) => "\u2605").join();

Function complement(int to) =>  (int nb) => to - nb;