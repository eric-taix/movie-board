library movie_board.utils;

//============= Utility functions ============

and(Iterable predicates) => (e) => predicates.every((p) => p(e));

or(Iterable predicates) => (e) => predicates.any((p) => p(e));

Function isType(Type type) => (m) => m.runtimeType == type;

Function notCurrent(current) => (m) => m != current;