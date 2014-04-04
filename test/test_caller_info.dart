import 'package:caller_info/caller_info.dart';
import 'package:path/path.dart' as pathos;
import 'package:unittest/unittest.dart';

void testGetLine() {
  var line = new CallerInfo().line;
  expect(line, 6, reason: "CallerInfo.line");
}

void main() {
  testGetClosure();
  testGetLine();
  testGetMethod();
  testGetSource();
  testGetType();
}

void testGetClosure() {
  var object = new Foo();
  var reason = "CallerInfo.closure for getter";
  expect(object.getter.closure, false, reason: reason);
  reason = "CallerInfo.closure for method";
  expect(object.method().closure, false, reason: reason);
  reason = "CallerInfo.closure for method with closure";
  expect(object.methodWithClosure().closure, true, reason: reason);
  reason =  "CallerInfo.closure for global method";
  expect(new CallerInfo().closure, false, reason: reason);
  reason = "CallerInfo.closure for global method with closure";
  var ci = (){ return new CallerInfo(); }();
  expect(ci.closure, true, reason: reason);
}

void testGetMethod() {
  var object = new Foo();
  var reason = "CallerInfo.type for getter";
  expect(object.getter.method, "getter", reason: reason);
  reason = "CallerInfo.type for method";
  expect(object.method().method, "method", reason: reason);
  reason = "CallerInfo.type for method with closure";
  expect(object.methodWithClosure().method, "methodWithClosure", reason: reason);
  reason =  "CallerInfo.type for global method";
  expect(new CallerInfo().method, "testGetMethod", reason: reason);
  reason = "CallerInfo.type for global method with closure";
  var ci = (){ return new CallerInfo(); }();
  expect(ci.method, "testGetMethod", reason: reason);
}

testGetSource() {
  var ci = new CallerInfo();
  var path = Uri.parse(ci.source).toFilePath();
  var file = pathos.basename(path);
  var reason = "CallerInfo.source";
  expect(file, "test_caller_info.dart", reason: reason);
}

void testGetType() {
  var object = new Foo();
  var className = object.runtimeType.toString();
  var reason = "CallerInfo.type for getter";
  expect(object.getter.type, className, reason: reason);
  reason = "CallerInfo.type for method";
  expect(object.method().type, className, reason: reason);
  reason = "CallerInfo.type for method with closure";
  expect(object.methodWithClosure().type, className, reason: reason);
  reason =  "CallerInfo.type for global method";
  expect(new CallerInfo().type, "", reason: reason);
  reason = "CallerInfo.type for global method with closure";
  var ci = (){ return new CallerInfo(); }();
  expect(ci.type, "", reason: reason);
}

class Foo {
  CallerInfo get getter => new CallerInfo();
  CallerInfo method() => new CallerInfo();
  CallerInfo methodWithClosure() => () { return new CallerInfo(); }();
}
