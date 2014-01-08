library movie_board.utils;

import 'dart:html';

//============= Utility functions ============

and(Iterable predicates) => (e) => predicates.every((p) => p(e));

or(Iterable predicates) => (e) => predicates.any((p) => p(e));

Function isType(Type type) => (m) => m.runtimeType == type;

Function notCurrent(current) => (m) => m != current;

/**
 *  Apply the selected class to the current class prefix
 *  It's useful when you want to visualize a current selected item and unselected neighbors items
 *  
 *  Returns true si the class has been applied to the target or false if the class was not applied
 */
bool applySelectedCSS(Element target, String classPrefix) {
  if (!target.classes.contains("${classPrefix}-selected")) {
    target.parent.children.forEach((Element ele) => ele.classes.remove("${classPrefix}-selected"));
    target.classes.add("${classPrefix}-selected");
    return true;
  }
  return false;
}