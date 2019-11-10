import "package:test/test.dart";
import 'main.dart';

void main() {
  test("challenge 2 a", () {
    expect(finalPoint({'x':50, 'y':60}, {'x': 100, 'y': 100}, 10), equals({'x': '57.81', 'y': '66.25'}));
  });


}