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
