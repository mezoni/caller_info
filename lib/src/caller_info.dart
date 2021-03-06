part of caller_info;

class CallerInfo {
  static const String _ANONYMOUS_CLOSURE = "<anonymous closure>";

  static final bool isBrowser = _Utils._dartIoMirror == null;

  String _caller;

  List<int> _callerSeparators = new List<int>();

  bool _closure;

  Uri _file;

  String _frame;

  int _frameEnd;

  int _frameStart;

  int _line = 0;

  String _method;

  String _source;

  int _sourceEnd;

  int _sourceStart;

  String _trace;

  String _type;

  CallerInfo() {
    try {
      throw "";
    } catch (e, s) {
      // "s.toString()" consuming 87% of the time
      _trace = s.toString();
      _parse();
    }
  }

  String get caller {
    return _caller;
  }

  bool get closure {
    if (_closure == null) {
      _parseCaller();
    }

    return _closure;
  }

  Uri get file {
    if (_file == null) {
      _file = _Utils.getSourceUri(source);
    }

    return _file;
  }

  String get frame {
    if (_frame == null) {
      if (_frameStart != null && _frameEnd != null) {
        _frame = _trace.substring(_frameStart, _frameEnd);
      } else {
        _frame = "";
      }
    }

    return _frame;
  }

  int get line => _line;

  String get method {
    if (_method == null) {
      _parseCaller();
    }

    return _method;
  }

  String get source {
    if (_source == null) {
      if (_sourceStart != null && _sourceEnd != null) {
        _source = _trace.substring(_sourceStart, _sourceEnd);
      } else {
        _source = "";
      }
    }

    return _source;
  }

  String get type {
    if (_type == null) {
      _parseCaller();
    }

    return _type;
  }

  String toString() => _frame;

  void _parse() {
    var length = _trace.length;
    var pos = 0;
    // Skip first line
    while (true) {
      if (pos == length) {
        return;
      }

      if (_trace.codeUnitAt(pos++) == 10) {
        break;
      }
    }

    if (pos == length) {
      return;
    }

    // Skip "#"
    if (_trace.codeUnitAt(pos++) != 35) {
      return;
    }

    // Skip "frame number"
    while (true) {
      if (pos == length) {
        return;
      }

      if (_trace.codeUnitAt(pos++) == 32) {
        break;
      }
    }

    // Skip spaces between "frame number" and "caller"
    while (true) {
      if (pos == length) {
        return;
      }

      if (_trace.codeUnitAt(pos++) != 32) {
        break;
      }
    }

    _frameStart = pos - 1;
    // Parse "caller"
    while (true) {
      if (pos == length) {
        return;
      }

      var c = _trace.codeUnitAt(pos++);
      if (c == 46) {
        _callerSeparators.add(pos - _frameStart - 1);
      } else if (c == 40) {
        var end = pos - 1;
        while (true) {
          if (_trace.codeUnitAt(end--) != 32) {
            break;
          }
        }

        _caller = _trace.substring(_frameStart, end);
        break;
      }
    }

    // Parse "source url"
    _sourceStart = pos;
    var separators = [];
    while (true) {
      if (pos == length) {
        return;
      }

      var c = _trace.codeUnitAt(pos++);
      if (c == 58) {
        separators.add(pos - 1);
      } else if (c == 41) {
        break;
      }
    }

    // Locate "line number"
    _sourceEnd = pos - 1;
    var lineLength = 0;
    for (int start,
        i = separators.length - 1; i >= 0; i--, lineLength = _sourceEnd - start, _sourceEnd = start - 1) {
      start = separators[i] + 1;
      var success = false;
      for (var j = start; j < _sourceEnd; j++) {
        var c = _trace.codeUnitAt(j);
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
    if (_sourceEnd != pos - 1) {
      var number = 0;
      var power = 1;
      var start = _sourceEnd + 1;
      for (var i = lineLength - 1; i >= 0; i--, power *= 10) {
        number += (_trace.codeUnitAt(start + i) - 48) * power;
      }

      _line = number;
    }


    _frameEnd = pos;
  }

  void _parseCaller() {
    var caller = this.caller;
    _closure = false;
    _method = "";
    _type = "";
    var length = _caller.length;
    var count = _callerSeparators.length;
    if (count == 0) {
      _method = _caller;
      return;
    }

    var start = _callerSeparators[0] + 1;
    var next = count == 1 ? length : _callerSeparators[1];
    var part2 = _caller.substring(start, next);
    if (part2 == _ANONYMOUS_CLOSURE) {
      _method = _caller.substring(0, start - 1);
      _closure = true;
      return;
    }

    _type = _caller.substring(0, start - 1);
    _method = _caller.substring(start, next);
    if (count > 1) {
      _closure = true;
    }
  }
}

class _Utils {
  static final LibraryMirror _dartIoMirror = _getDartIoMirror();

  static final bool _isWindows = _getIsWindows();

  static final String _separator = _isWindows ? "\\" : "/";

  static final String _packageRoot = _getPackageRoot();

  static final int _windowsSeparator = _isWindows ? 92 : null;

  static Uri getSourceUri(String source) {
    if (source == null || source.isEmpty) {
      return new Uri();
    }

    var uri = Uri.parse(source);
    switch (uri.scheme) {
      case "dart":
      case "dart-ext":
        return new Uri();
      case "package":
        var packageRoot = _packageRoot;
        if (packageRoot == null) {
          return new Uri();
        }

        return Uri.parse(_join(packageRoot, uri.path));
    }

    return uri;
  }

  static String _dirname(String uri) {
    var length = uri.length;
    if (length == null) {
      return uri;
    }

    var found = false;
    var position = length - 1;
    while (true) {
      if (position < 0) {
        break;
      }

      var c = uri.codeUnitAt(position--);
      if (c == 47 || c == _windowsSeparator) {
        found = true;
        break;
      }
    }

    if (!found) {
      return uri;
    }

    return uri.substring(0, position + 1);
  }

  static LibraryMirror _getDartIoMirror() {
    return currentMirrorSystem().libraries[Uri.parse("dart:io")];
  }

  static bool _getIsWindows() {
    if (_dartIoMirror == null) {
      return false;
    }

    ClassMirror platform = _dartIoMirror.declarations[#Platform];
    return platform.getField(#isWindows).reflectee;
  }

  static String _getPackageRoot() {
    if (_dartIoMirror == null) {
      var base = Uri.base.toString();
      if (base.isEmpty) {
        return null;
      }

      return _join(_dirname(base), "packages");
    }

    ClassMirror platform = _dartIoMirror.declarations[#Platform];
    String packageRoot = platform.getField(#packageRoot).reflectee;
    var packages = "packages";
    if (!packageRoot.isEmpty) {
      if (pathos.isAbsolute(packageRoot)) {
        var path = pathos.normalize(packageRoot);
        if (_isWindows) {
          path = path.replaceAll("\\", "/");
        }

        return new Uri(scheme: "file", path: path).toString();
      }

      packages = pathos.normalize(packageRoot);
      if (_isWindows) {
        packages = packages.replaceAll("\\", "/");
      }
    }

    String script = platform.getField(#script).reflectee.toString();
    if (script.isEmpty) {
      return null;
    }

    return _join(_dirname(script), packages);
  }

  static String _join(String part1, String part2) {
    if (part2.isEmpty) {
      return part1;
    }

    //return "$part1$_separator$part2";
    return "$part1/$part2";
  }
}
