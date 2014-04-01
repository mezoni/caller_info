caller_info
===========

Caller info (caller, closure, frame, line, method, path, source, type).

```dart
import 'package:caller_info/caller_info.dart';

void main() {
  printInfo(new CallerInfo());
  new Foo().test();
}

class Foo {
  void test() {
    (() => printInfo(new CallerInfo()))();
  }
}

void printInfo(CallerInfo ci) {
  print("==============");
  print("frame: ${ci.frame}");
  print("source: ${ci.source}");
  print("path: ${CallerInfo.toFilePath(ci.source)}");
  print("line: ${ci.line}");
  print("caller: ${ci.caller}");
  print("type: ${ci.type}");
  print("method: ${ci.method}");
  print("closure: ${ci.closure}");
}
```

Output:

```
==============
frame: main (file:///home/andrew/dart/caller_info/example/example.dart:4:17)
source: file:///home/andrew/dart/caller_info/example/example.dart
path: /home/andrew/dart/caller_info/example/example.dart
line: 4
caller: main
type: 
method: main
closure: false
==============
frame: Foo.test.<anonymous closure> (file:///home/andrew/dart/caller_info/example/example.dart:10:26)
source: file:///home/andrew/dart/caller_info/example/example.dart
path: /home/andrew/dart/caller_info/example/example.dart
line: 10
caller: Foo.test.<anonymous closure>
type: Foo
method: test
closure: true
```