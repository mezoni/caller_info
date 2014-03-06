import 'package:caller_info/caller_info.dart';

void main() {
  Foo.test();
  try {
    Foo.coolMethod();
  } catch(e) {
    print(e);
  }
}

class Foo {
  static void test() {
    var ci = new CallerInfo();
    print("frame: ${ci.frame}");
    print("source: ${ci.source}");
    print("caller: ${ci.caller}");
    print("line: ${ci.line}");
  }

  static void coolMethod() {
    throw new UnimplementedError(new CallerInfo().caller);
  }
}
