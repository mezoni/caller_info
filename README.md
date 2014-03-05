caller_info
===========

Caller info (file, class, method, line number)

```dart
import 'package:caller_info/caller_info.dart';

void main() {
  Foo.test();
}

class Foo {
  static void test() {
    var ci = new CallerInfo();
    print("file: ${ci.fileName}");
    print("class: ${ci.className}");
    print("method: ${ci.methodName}");
    print("line: ${ci.lineNumber}");
  }
}
```
