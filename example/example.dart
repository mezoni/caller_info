import 'package:caller_info/caller_info.dart';

void main() {
  print(new CallerInfo());
  new Foo();
  test();
  var count = 10000;
  var sw = new Stopwatch();
  sw.start();
  for(var i = 0; i < count; i++) {
    new CallerInfo();
  }

  sw.stop();
  var elapsedTime = sw.elapsedMicroseconds;
  if(elapsedTime > 0) {
    var throughput = (1000000 / elapsedTime * count).toInt();
    print("Throughput: $throughput per second");
  } else {
  }
}

class Foo {
  Foo() {
    _test();
  }

  void _test() {
    print(new CallerInfo());
  }
}

void test() {
  var ci = new CallerInfo();
  print("file: ${ci.fileName}");
  print("class: ${ci.className}");
  print("method: ${ci.methodName}");
  print("line: ${ci.lineNumber}");
}
