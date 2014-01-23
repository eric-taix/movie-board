library movie_board.utils;

import 'dart:html';
import 'dart:async';

/// Function which generates stars
Function intToStars() => (int nb) => new List.generate(nb, (_) => "\u2605").join();

/// Function which returns a CSS style according
Function selectedToClass(String prefix) => (bool selected) => selected ? "${prefix}-selected" : prefix;

/// Function which converts a [String] to an [int]
Function stringToInt() => (String value) => int.parse(value); 

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

/**
 * Apply a function after a certain amout of milliseconds and reset it if a timer has been alredy launched
 */
Timer timer = null;
applyDelayed(int ms, Function f) {
  // If there's an active timer then reset it
  if (timer != null && timer.isActive) timer.cancel();
  // Apply the searchTerm to the searchFilter after a certain amout of time
  timer = new Timer(new Duration(milliseconds: 400), () {
    f();
    timer = null;
  });
}