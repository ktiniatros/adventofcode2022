import 'package:advent/common.dart';
import 'package:quiver/iterables.dart';

const int lowerCaseCodeUnitOffset = 96;
const int upperCaseCodeUnitOffset = 38;

List<int> convertCharsToScores(String line) {
  return line.codeUnits.map((e) {
    if (e > lowerCaseCodeUnitOffset) {
      return e - lowerCaseCodeUnitOffset;
    } else {
      return e - upperCaseCodeUnitOffset;
    }
  }).toList();
}

int lineScore(String line) {
  final rucksack = convertCharsToScores(line);
  final compartments = partition(rucksack, rucksack.length ~/ 2).toList();
  final secondCompartmentRemaining = compartments[1].toList(growable: true);
  final commonElements = compartments[0].where((element) {
    final contained = secondCompartmentRemaining.remove(element);
    return contained;
  }).toList();
  return commonElements.toSet().reduce((value, element) => value + element);
}

int cast(el) => el is int ? el : 0;

int splitLines(List<String> lines) {
  final linesScores = lines.map((e) => convertCharsToScores(e));
  final groups = partition(linesScores, 3).toList();

  final badges = groups.map((list) {
    return list.fold<Set>(
        list.first.toSet(),
            (a, b) => a.intersection(b.toSet()));
  });

  return badges.map((e) => cast((e as Set<int>).first)).reduce((value, element) => value + element);
}

Future<void> solve() async {
  await readLines("3.txt").then((lines) {
    final finalScore = lines.map((e) => lineScore(e)).toList().reduce((value, element) => value + element);
    final finalScore2 = splitLines(lines);
    print("Day 3, Ex1: $finalScore");
    print("Day 3, Ex2: $finalScore2");
  });
}