// Challenge 1
// Flutter module makes multiple, parallel, requests to a web service, and
// shares the result with the host app. We'll use the "balldontlie" API for this
// purpose, since it's open and supports cross-domain requests for web apps. in
// this case, the input value represents the number of calls to be made, eg a
// value of 3 means we will fetch data for players 1, 2, 3. The URL for player 2,
// for example, is:
// https://www.balldontlie.io/api/v1/players/1
// Once all calls have been made, the Flutter module should calculate average
// weight of all queried players and print it in console.
//  The calls must occur in parallel, always using up to *four* separate threads,
// in a typical "worker" pattern, to ensure there are always three pending requests
// until no further requests are needed. The requests should be logged when initiated
// and again when completed.

// Challenge 2
// A point on the screen (pt1) wants to move a certain distance (dist) closer to
// another point on the screen (pt2) The function has three arguments,
// two of which are objects with x & y values, and the third being the distance,
// e.g. {x:50, y:60}, {x: 100, y: 100}, 10. The expected result is a similar
// object with the new co-ordinate.
import 'dart:math';
import 'package:executor/executor.dart';
import 'package:http/http.dart' as http;
import 'package:executorservices/executorservices.dart';
import "dart:async";
import 'dart:convert';
import "dart:math";


finalPoint(Map<String,int> firstPoint,Map<String,int> secondPoint,int distanceToMove){
  int xSquaresDiff = pow((firstPoint['x'] - secondPoint['x']).abs(),2);
  int ySquaresDiff = pow((firstPoint['y'] - secondPoint['y']).abs(),2);
  int sumOfSquares = xSquaresDiff + ySquaresDiff;
  double distanceRemaining = sqrt(sumOfSquares) - distanceToMove;
  double xPoint = ((distanceToMove * secondPoint['x']) + (distanceRemaining*firstPoint['x'])) / (sqrt(sumOfSquares));
  double yPoint = ((distanceToMove * secondPoint['y']) + (distanceRemaining*firstPoint['y'])) / (sqrt(sumOfSquares));
  return {'x':xPoint.toStringAsFixed(2),'y':yPoint.toStringAsFixed(2)};
}



Stream<String> getPosts(final int max) async* {
  for (int index = 0; index < max; index++) {
    final post = await http.get(
      "https://www.balldontlie.io/api/v1/players/$index",
    );
    yield post.body;

//    String playerWeight = jsonDecode(post.body)['weight_pounds'];
//    yield playerWeight;
  }
}


int sum = 0;
Future<int> returnId(final dynamic map) async {
  await Future.delayed(Duration(seconds: 1));
  print(map['weight_pounds']);
  if(map['weight_pounds'] != null){
    sum = sum + map['weight_pounds'];
  }

  return map['id'];
}



main() {
  final executorService = ExecutorService.newFixedExecutor(3);
  executorService
      .subscribeToCallable(getPosts, 10)
      .asyncMap(
        (post) => executorService.submitCallable(returnId, jsonDecode(post)),
  )
      .listen(
        (number) => print("event received: $number"),
    onError: (error) => print("error received $error"),
    onDone: () => print(sum),
  );
  print(finalPoint({'x':50, 'y':60}, {'x': 100, 'y': 100}, 10));
}
