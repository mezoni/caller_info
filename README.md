caller_info
===========

Caller info (frame, source, caller, line number)

```dart
import 'package:caller_info/caller_info.dart';

void main() {
  Foo.test();
}

class Foo {
  static void test() {
    var ci = new CallerInfo();
    print("frame: ${ci.frame}");
    print("source: ${ci.source}");
    print("caller: ${ci.caller}");
    print("line: ${ci.line}");
  }
}
```

Output:

```
frame: Foo.test (file:///home/andrew/dart//caller_info/example/example.dart:9:18)
source: file:///home/andrew/dart/caller_info/example/example.dart
caller: Foo.test
line: 9
```