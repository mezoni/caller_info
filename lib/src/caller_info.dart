part of caller_info.caller_info;

class CallerInfo {
  static const String _ANONYMOUS_CLOSURE = "<anonymous closure>";

  String caller = "";

  bool closure = false;

  String frame = "";

  int line = 0;

  String method = "";

  String source = "";

  String type = "";

  CallerInfo() {
    try {
      throw "";
    } catch (e, s) {
      // "s.toString()" consuming 87% of the time
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

    // Skip spaces between "frame number" and "caller"
    while (true) {
      if (pos == length) {
        return;
      }

      if (trace.codeUnitAt(pos++) != 32) {
        break;
      }
    }

    var frameStart = pos - 1;

    // Parse "caller"
    var callerSeparators = new List<int>();
    while (true) {
      if (pos == length) {
        return;
      }

      var c = trace.codeUnitAt(pos++);
      if (c == 46) {
        callerSeparators.add(pos - frameStart - 1);
      } else if (c == 40) {
        var end = pos - 1;
        while (true) {
          if (trace.codeUnitAt(end--) != 32) {
            break;
          }
        }

        caller = trace.substring(frameStart, end);
        break;
      }
    }

    // Parse "source url"
    var sourceStart = pos;
    var separators = [];
    while (true) {
      if (pos == length) {
        return;
      }

      var c = trace.codeUnitAt(pos++);
      if (c == 58) {
        separators.add(pos - 1);
      } else if (c == 41) {
        break;
      }
    }

    // Locate "line number"
    var sourceEnd = pos - 1;
    var lineLength = 0;
    for (int start, i = separators.length - 1; i >= 0; i--, lineLength = sourceEnd - start, sourceEnd = start - 1) {
      start = separators[i] + 1;
      var success = false;
      for (var j = start; j < sourceEnd; j++) {
        var c = trace.codeUnitAt(j);
        if (c >= 48 && c <= 57) {
          success = true;
        } else {
          success = false;
          break;
        }
      }

      if (!success) {
        break;
      }
    }

    // Parse "line number"
    if (sourceEnd != pos - 1) {
      var number = 0;
      var power = 1;
      var start = sourceEnd + 1;
      for (var i = lineLength - 1; i >= 0; i--, power *= 10) {
        number += (trace.codeUnitAt(start + i) - 48) * power;
      }

      line = number;
    }

    // Combine "source"
    source = trace.substring(sourceStart, sourceEnd);
    frame = trace.substring(frameStart, pos);

    // Parse type, method, closure
    length = caller.length;
    var count = callerSeparators.length;
    if (count == 0) {
      method = caller;
      return;
    }

    var start = callerSeparators[0] + 1;
    var next = count == 1 ? length : callerSeparators[1];
    var part2 = caller.substring(start, next);
    if (part2 == _ANONYMOUS_CLOSURE) {
      method = caller.substring(0, start - 1);
      closure = true;
      return;
    }

    type = caller.substring(0, start - 1);
    method = caller.substring(start, next);
    if (count > 1) {
      closure = true;
    }
  }

  String toString() => frame;
}
