import 'package:caller_info/caller_info.dart';
import 'package:unittest/unittest.dart';

void main() {
  var ci = new CallerInfo();
  check(ci, {"caller": "main", "line": 5});
  () { () { ci = new CallerInfo(); } (); } ();
  check(ci, {"caller": "main.<anonymous closure>.<anonymous closure>", "line": 7});
  ci = new Test().test;
  check(ci, {"caller": "Test.test", "line": 14});
}

class Test {
  CallerInfo get test => new CallerInfo();
}

void check(CallerInfo ci, Map values) {
  expect(ci.caller, values["caller"], reason: "caller");
  expect(ci.line, values["line"], reason: "line");
}
