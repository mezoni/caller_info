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
  print("line: ${ci.line}");
  print("caller: ${ci.caller}");
  print("type: ${ci.type}");
  print("method: ${ci.method}");
  print("closure: ${ci.closure}");
}
