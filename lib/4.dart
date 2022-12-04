import 'package:advent/common.dart';

List<List<int>> _parseLine(String line) {
  final assignmentPair = line.split(",");
  return assignmentPair.map((e) {
    final pair = e.split("-").map((e) => int.parse(e)).toList();
    return List.generate(pair[1] - pair[0] + 1, (index) => pair[0] + index);
  }).toList();
}

bool isFullyContained(List<List<int>> assignmentPairs) {
  final firstPair = assignmentPairs[0].toSet();
  final secondPair = assignmentPairs[1].toSet();
  return firstPair.containsAll(secondPair) || secondPair.containsAll(firstPair);
}

bool isPartiallyContained(List<List<int>> assignmentPairs) {
  final firstPair = assignmentPairs[0].toSet();
  final secondPair = assignmentPairs[1].toSet();

  return firstPair.intersection(secondPair).isNotEmpty || secondPair.intersection(firstPair).isNotEmpty;
}

Future<void> solve() async {
  await readLines("4.txt").then((lines) {
    final finalScore = lines.map((e) => _parseLine(e)).map((e) => isFullyContained(e)).where((element) => element == true).length;
    final finalScore2 = lines.map((e) => _parseLine(e)).map((e) => isPartiallyContained(e)).where((element) => element == true).length;
    print("Day 4, Ex1: $finalScore");
    print("Day 4, Ex2: $finalScore2");
  });
}