library movie.utils;

import 'dart:html';

Function intToStars = (int nb) => new List.generate(nb, (_) => "\u2605").join();

Function complement(int to) =>  (int nb) => to - nb;

applySelectedCSS(Element target, String classPrefix) {
  String classname = "${classPrefix}-selected";
  if (!target.classes.contains(classname)) {
    target.parent.children.forEach((e) => e.classes.remove(classname));
    target.classes.add(classname);
   }
}