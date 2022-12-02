import 'package:advent/common.dart';

final scores = {
  'A': 1,
  'B': 2,
  'C': 3,
  'X': 1,
  'Y': 2,
  'Z': 3,
};

final outcomesIndex = {
  'A': 0,
  'B': 1,
  'C': 2,
  'X': 0,
  'Y': 1,
  'Z': 2,
};

/// Possible score outcomes of 1st player vs 2nd player
/// 1st player is vertically: Rock
///                           Paper
///                           Scissors
/// 2nd player is horizontally: Rock, Paper, Scissors
final possibleOutcomes = [
  [3, 6, 0],
  [0, 3, 6],
  [6, 0, 3]
];



int lineScore(String line) {
  final result = line.split(" ");
  final choiceScore = scores[result[1]]!;
  final otherPlayerIndex = outcomesIndex[result[0]]!;
  final myIndex = outcomesIndex[result[1]]!;
  return possibleOutcomes[otherPlayerIndex][myIndex] + choiceScore;
}

///X means you need to lose, Y means you need to end the round in a draw, and Z means you need to win
///
final scores2 = {
  'X': 0,
  'Y': 3,
  'Z': 6,
};

final choiceScore2 = {
  0: 1,
  1: 2,
  2: 3,
};

int lineScore2(String line) {
  final result = line.split(" ");
  final resultScore = scores2[result[1]]!;
  final otherPlayerIndex = outcomesIndex[result[0]]!;
  final myIndex = possibleOutcomes[otherPlayerIndex].indexOf(resultScore);

  return resultScore + choiceScore2[myIndex]!;
}

Future<void> solve() async {
  await readLines("2.txt").then((lines) {
    final finalScore = lines.map((e) => lineScore(e)).toList().reduce((value, element) => value + element);
    final finalScore2 = lines.map((e) => lineScore2(e)).toList().reduce((value, element) => value + element);
    print("Day 2, Ex1: $finalScore");
    print("Day 2, Ex2: $finalScore2");
  });
}
