caller_info
===========

Caller info (caller, closure, frame, line, method, source, type).

```dart
import 'package:caller_info/caller_info.dart';

void main() {
  printInfo(new CallerInfo());
  Foo.test();
  new Foo().testClosure();
}

class Foo {
  static void test() {
    printInfo(new CallerInfo());
  }

  void testClosure() {
    (() => printInfo(new CallerInfo()))();
  }
}

void printInfo(CallerInfo ci) {
  print("======= Caller info =======");
  print("frame: ${ci.frame}");
  print("source: ${ci.source}");
  print("line: ${ci.line}");
  print("caller: ${ci.caller}");
  print("type: ${ci.type}");
  print("method: ${ci.method}");
  print("closure: ${ci.closure}");
}
```

Output:

```
======= Caller info =======
frame: main (file:///home/andrew/dart/caller_info/example/example.dart:4:17)
source: file:///home/andrew/dart/caller_info/example/example.dart
line: 4
caller: main
type: 
method: main
closure: false
======= Caller info =======
frame: Foo.test (file:///home/andrew/dart/caller_info/example/example.dart:11:19)
source: file:///home/andrew/dart/caller_info/example/example.dart
line: 11
caller: Foo.test
type: Foo
method: test
closure: false
======= Caller info =======
frame: Foo.testClosure.<anonymous closure> (file:///home/andrew/dart/caller_info/example/example.dart:15:26)
source: file:///home/andrew/dart/caller_info/example/example.dart
line: 15
caller: Foo.testClosure.<anonymous closure>
type: Foo
method: testClosure
closure: true
```