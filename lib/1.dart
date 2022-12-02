import 'dart:io';

import 'package:advent/common.dart';

List<int> sortedLines(List<dynamic> lines) {
  final List<int> caloriesSumList = [];
  caloriesSumList.add(
      lines.map((e) => int.tryParse(e) ?? -1).toList().reduce((value, element) {
        if (element == -1) {
          caloriesSumList.add(value);
          return 0;
        } else {
          return value + element;
        }
      }));

  caloriesSumList.sort((a, b) => a - b);
  return caloriesSumList;
}

// sum lines and return biggest sum
int sumLines(List<dynamic> lines) {
  return sortedLines(lines).last;
}

// sum lines and return biggest sum of three greater values
int sumThreeLines(List<dynamic> lines) {
  final linesSorted = sortedLines(lines);
  return linesSorted.getRange(linesSorted.length - 3, linesSorted.length).reduce((
      value, element) => value + element);
}

Future<void> solve() async {
  await readLines("1.txt").then((lines) {
    print("Day 1, Ex1: ${sumLines(lines)}");
    print("Day 1, Ex2: ${sumThreeLines(lines)}");
  });
}
