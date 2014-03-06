part of caller_info.caller_info;

class CallerInfo {
  String frame = "";

  String caller = "";

  int line = 0;

  String source = "";

  CallerInfo() {
    try {
      throw null;
    } catch (e, s) {
      var sw = new Stopwatch();
      _parse(s.toString());
    }
  }

  void _parse(String trace) {
    var length = trace.length;
    var pos = 0;
    // Skip first line
    while (true) {
      if (pos == length) {
        return;
      }

      if (trace.codeUnitAt(pos++) == 10) {
        break;
      }
    }

    if (pos == length) {
      return;
    }

    // Skip "#"
    if (trace.codeUnitAt(pos++) != 35) {
      return;
    }

    // Skip "frame number"
    while (true) {
      if (pos == length) {
        return;
      }

      if (trace.codeUnitAt(pos++) == 32) {
        break;
      }
    }

    int c;
    // Skip spaces between "frame number" and "caller"
    while (true) {
      if (pos == length) {
        return;
      }

      c = trace.codeUnitAt(pos++);
      if (c != 32) {
        break;
      }
    }

    // Parse "caller"
    var start = pos - 1;
    while(true) {
      if (pos == length) {
        return;
      }

      c = trace.codeUnitAt(pos++);
      if (c == 40) {
        var end = pos - 1;
        while(true) {
          if(trace.codeUnitAt(end--) != 32) {
            break;
          }
        }

        caller = trace.substring(start, end);
        break;
      }
    }

    // Parse "source url"
    var part = [];
    var fileParts = [part];
    while (true) {
      if (pos == length) {
        return;
      }

      c = trace.codeUnitAt(pos++);
      if (c == 41) {
        break;
      }

      if (c == 58) {
        part = [];
        fileParts.add(part);
        continue;
      }

      part.add(c);
    }

    // Locate "line number" part
    var partsCount = fileParts.length;
    int lastPart;
    List linePart;
    for (lastPart = partsCount - 1; lastPart >= 0; lastPart--) {
      var part = fileParts[lastPart];
      var length3 = part.length;
      bool success;
      for (var j = 0; j < length3; j++) {
        var c = part[j];
        if (c >= 48 && c <= 57) {
          success = true;
        } else {
          success = false;
          break;
        }
      }

      if (success == true) {
        linePart = part;
      } else {
        break;
      }
    }

    // Parse "line number"
    if (linePart != null) {
      var length = linePart.length;
      var number = 0;
      var power = 1;
      for (var i = length - 1; i >= 0; i--, power *= 10) {
        number += (linePart[i] - 48) * power;
      }

      line = number;
    }

    // Combine "file name"
    var charCodes = new List();
    for (var i = 0; i <= lastPart; i++) {
      if (i > 0) {
        charCodes.add(58);
      }

      var part = fileParts[i];
      var length = part.length;
      for (var j = 0; j < length; j++) {
        charCodes.add(part[j]);
      }
    }

    source = new String.fromCharCodes(charCodes);
    frame = trace.substring(start, pos);
  }

  String toString() => frame;
}

/*
class CallerInfo {
  String className = "";

  String fileName = "";

  int lineNumber = 0;

  String methodName = "";

  CallerInfo() {
    try {
      throw null;
    } catch (e, s) {
      _parse(s.toString());
    }
  }

  void _parse(String trace) {
    var length = trace.length;
    var pos = 0;
    // Skip first line
    while (true) {
      if (pos == length) {
        return;
      }

      if (trace.codeUnitAt(pos++) == 10) {
        break;
      }
    }

    if (pos == length) {
      return;
    }

    // Skip "#"
    if (trace.codeUnitAt(pos++) != 35) {
      return;
    }

    // Skip "frame number"
    while (true) {
      if (pos == length) {
        return;
      }

      if (trace.codeUnitAt(pos++) == 32) {
        break;
      }
    }

    int c;
    // Skip spaces between "frame number" and "qualified identifier"
    while (true) {
      if (pos == length) {
        return;
      }

      c = trace.codeUnitAt(pos++);
      if (c != 32) {
        break;
      }
    }

    // Parse "qualified identifier"
    var firstPart = [c];
    List secondPart;
    var part = firstPart;
    while (true) {
      if (pos == length) {
        return;
      }

      c = trace.codeUnitAt(pos++);
      if (c == 32) {
        break;
      }

      if (c == 46) {
        part = secondPart = [];
        continue;
      }

      part.add(c);
    }

    if (secondPart == null) {
      methodName = new String.fromCharCodes(firstPart);
    } else {
      className = new String.fromCharCodes(firstPart);
      methodName = new String.fromCharCodes(secondPart);
    }

    // Skip spaces between "qualified identifier" and "url"
    while (true) {
      if (pos == length) {
        return;
      }

      c = trace.codeUnitAt(pos++);
      if (c != 32) {
        break;
      }
    }

    if (pos == length) {
      return;
    }

    // Skip "("
    if (c != 40) {
      return;
    }

    // Parse "url"
    part = [];
    var fileParts = [part];
    while (true) {
      if (pos == length) {
        return;
      }

      c = trace.codeUnitAt(pos++);
      if (c == 41) {
        break;
      }

      if (c == 58) {
        part = [];
        fileParts.add(part);
        continue;
      }

      part.add(c);
    }

    // Locate "line number" part
    var partsCount = fileParts.length;
    int lastPart;
    List linePart;
    for (lastPart = partsCount - 1; lastPart >= 0; lastPart--) {
      var part = fileParts[lastPart];
      var length3 = part.length;
      bool success;
      for (var j = 0; j < length3; j++) {
        var c = part[j];
        if (c >= 48 && c <= 57) {
          success = true;
        } else {
          success = false;
          break;
        }
      }

      if (success == true) {
        linePart = part;
      } else {
        break;
      }
    }

    // Parse "line number"
    if (linePart != null) {
      var length = linePart.length;
      var number = 0;
      var power = 1;
      for (var i = length - 1; i >= 0; i--, power *= 10) {
        number += (linePart[i] - 48) * power;
      }

      lineNumber = number;
    }

    // Combine "file name"
    var charCodes = new List();
    for (var i = 0; i <= lastPart; i++) {
      if(i > 0) {
        charCodes.add(58);
      }

      var part = fileParts[i];
      var length = part.length;
      for(var j = 0; j < length; j++) {
        charCodes.add(part[j]);
      }
    }

    fileName = new String.fromCharCodes(charCodes);
  }

  String toString() {
    if(className != null && !className.isEmpty) {
      return "$className.$methodName $fileName:$lineNumber";
    }

    return "$methodName $fileName:$lineNumber";
  }
}
*/
