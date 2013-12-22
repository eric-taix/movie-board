library movies.utils;

/**
 * Utility functions
 */


/**
 * Each predicate must match
 */
and(Iterable predicates) => (e) => predicates.every((p) => p(e));

/**
 * At least one predicate much match
 */
or(Iterable predicates) => (e) => predicates.any((p) => p(e));


Function isType(Type type) => (m) => m.runtimeType == type;

Function notCurrent(current) => (m) => m != current;