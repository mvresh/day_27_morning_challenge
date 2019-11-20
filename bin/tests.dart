import "package:test/test.dart";
import 'main.dart';
import 'package:http/http.dart' as http;
import 'package:executorservices/executorservices.dart';
import "dart:async";
import 'dart:convert';
import 'dart:math';

void main() {
  test("challenge 2 a", () {
    expect(finalPoint({'x':50, 'y':60}, {'x': 100, 'y': 100}, 10), equals({'x': '57.81', 'y': '66.25'}));
  });

  test("challenge executor 1", () {

    expect(finalPoint({'x':50, 'y':60}, {'x': 100, 'y': 100}, 10), equals({'x': '57.81', 'y': '66.25'}));
  });


}