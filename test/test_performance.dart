import 'package:caller_info/caller_info.dart';

void main() {
  var count = 10000;
  measure("Caller info", () {
    for(var i = 0; i < count; i++) {
      new CallerInfo();
    }
  });
}

void measure(String message, Function f) {
  var sw = new Stopwatch();
  sw.start();
  f();
  sw.stop();
  print("$message: ${sw.elapsedMilliseconds}");
}
