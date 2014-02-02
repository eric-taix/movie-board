library movie.utils;

import 'dart:html';

applySelectedCSS(Element target, String classPrefix) {
  String classname = "${classPrefix}-selected";
  if (!target.classes.contains(classname)) {
    target.parent.children.forEach((e) => e.classes.remove(classname));
    target.classes.add(classname);
   }
}


