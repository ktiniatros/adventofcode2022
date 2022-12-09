import 'dart:math';

import 'package:advent/common.dart';
import 'package:dartx/dartx.dart';

List<List<String>> positions = List.generate(1400, (index) => List.generate(1400, (_) => '.'));
List<List<String>> positions2 = List.generate(1400, (index) => List.generate(1400, (_) => '.'));

final startingX = 1000;
final startingY = 1000;
var headPosition = [startingX, startingY];
var tailPosition = [startingX, startingY];
var knotsPositions = [
  [startingX, startingY],
  [startingX, startingY],
  [startingX, startingY],
  [startingX, startingY],
  [startingX, startingY],
  [startingX, startingY],
  [startingX, startingY],
  [startingX, startingY],
  [startingX, startingY],
];

void moveAll(List<String> lines) {
  for (var element in lines) {
    final command = element.split(" ");
    final moveLength = int.parse(command[1]);
    for (var i = 1; i <= moveLength; i++) {
      parseHeadMove(command[0]);
      parseTailMove(headPosition, tailPosition, command[0]);
      positions[tailPosition[0]][tailPosition[1]] = '#';
    }
  }
}

void moveAll2(List<String> lines) {
  for (var element in lines) {
    final command = element.split(" ");
    final moveLength = int.parse(command[1]);
    for (var i = 1; i <= moveLength; i++) {
      parseHeadMove(command[0]);
      for (var j = 0; j < knotsPositions.length; j++) {
        if (j == 0) {
          parseTailMove(headPosition, knotsPositions[j], command[0]);
        } else {
          parseTailMove(knotsPositions[j - 1], knotsPositions[j], command[0]);
        }
      }
      if (positions2[knotsPositions[8][0]][knotsPositions[8][1]] != '#') {
        // print('tail position: ${knotsPositions[8]}');
      }
      positions2[knotsPositions[8][0]][knotsPositions[8][1]] = '#';
    }
    // print('final tail position for this round: ${knotsPositions[8]}');
  }
}

int offset(int value) {
  if (value > 0) {
    return -1;
  } else {
    return 1;
  }
}

void parseTailMove(List<int> headPosition, List<int> tailPosition, String direction) {
  final xDiff = headPosition[0] - tailPosition[0];
  final yDiff = headPosition[1] - tailPosition[1];
  final xDistance = xDiff.abs();
  final yDistance = yDiff.abs();

  if (xDistance == 1 && yDistance > 1) {
    // [4, 2];
    // [3, 0];
    // ......
    // ..H...
    // ......
    // .T...
    // s.....
    tailPosition[0] = headPosition[0];
    tailPosition[1] = (tailPosition[1]  + yDiff + offset(yDiff)).abs();
  } else if (yDistance == 1 && xDistance > 1) {
    // ......
    // ......
    // ......
    // ....T.
    // s.H...
    tailPosition[1] = headPosition[1];
    tailPosition[0] = (tailPosition[0]  + xDiff + offset(xDiff)).abs();
  } else if (xDistance > 1 && yDistance == 0) {
    // ......
    // ......
    // ......
    // ......
    // sH.T..
    tailPosition[0] = (tailPosition[0]  + xDiff + offset(xDiff)).abs();
  } else if (yDistance > 1 && xDistance == 0) {
    // ..H...
    // ......
    // ..T...
    // ......
    // s.....
    tailPosition[1] = (tailPosition[1]  + yDiff + offset(yDiff)).abs();
  } else if (xDistance > 1 && yDistance > 1) {
    // ......     ......
    // ......     ......
    // ......     ....H.
    // ....H.     .4321.
    // 4321..     5.....

    // ......     ......
    // ......     ......
    // ......     ......
    // ......     ...21.
    // ..21..     ......

    // [4, 1]
    // [2, 0]
    if (direction == 'U' || direction == 'D') {
      tailPosition[1] = headPosition[1];
      tailPosition[0] = (tailPosition[0]  + xDiff + offset(xDiff)).abs();
    } else {
      tailPosition[0] = headPosition[0];
      tailPosition[1] = (tailPosition[1]  + yDiff + offset(yDiff)).abs();
    }
  } else {
    if (xDistance > 1 || yDistance > 1) {
      print('untracked movement $xDistance $yDistance');
    }

  }
}

void parseHeadMove(String move) {
  switch (move) {
    case 'R':
      headPosition[0] += 1;
      break;
    case 'L':
      headPosition[0] -= 1;
      break;
    case 'U':
      headPosition[1] += 1;
      break;
    case 'D':
      headPosition[1] -= 1;
      break;
  }
}

// == Initial State ==
//
// ......
// ......
// ......
// ......
// H.....  (H covers T, s)
Future<void> solve() async {
  await readLines("9.txt").then((lines) {
    // positions[startingX][startingY] = '#';
    // print('moving rope1...');
    // moveAll(lines);
    // print('calculating moves1 done..');
    // final finalScore = positions.flatten().where((element) => element == '#').length;
    positions2[startingX][startingY] = '#';
    print('moving rope2...');
    moveAll2(lines);
    print('calculating moves2 done..');
    final finalScore2 = positions2.flatten().where((element) => element == '#').length;
    // print("Day 9, Ex1: $finalScore");
    print('2375 is too low');
    print("Day 9, Ex2: $finalScore2");
  });
}