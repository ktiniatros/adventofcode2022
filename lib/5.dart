import 'package:advent/common.dart';

String? _getCharacterOrNull(String line, int index) {
  if (line.length > index && line[index] != ' ') {
    return line[index];
  }
  return null;
}

// 0 -> 1
// 1 -> 5
// 2 -> 9
manipulateCrates(List<List<String>> stacks, String cratesLine) {
  for (var i = 0; i < cratesLine.length; i++) {
    final char = _getCharacterOrNull(cratesLine, i*4 + 1);
    if (char != null) {
      stacks[i].insert(0, char);
    }
  }
  return stacks;
}

moveCrates(List<List<String>> stacks, String moveLine, bool insert) {
  final lineCommands = moveLine.split(" ");
  final movesCount = int.parse(lineCommands[1]);
  final fromStack = int.parse(lineCommands[3]) - 1;
  final toStack = int.parse(lineCommands[5]) - 1;

  if (insert) {
    final elementsToMove = stacks[fromStack].getRange(stacks[fromStack].length - movesCount, stacks[fromStack].length);
    stacks[toStack].addAll(elementsToMove);
    stacks[fromStack].removeRange(stacks[fromStack].length - movesCount, stacks[fromStack].length);
  } else {
    for (var i = 0; i < movesCount; i++) {
      stacks[toStack].add(stacks[fromStack].last);
      stacks[fromStack].removeLast();
    }
  }
}

void parseLine(List<List<String>> stacks, String line, bool insert) {
  if (line.contains("[")) {
    manipulateCrates(stacks, line);
  }

  if (line.startsWith("move")) {
    moveCrates(stacks, line, insert);
  }
}

List<List<String>> findStacksCount(List<String> lines) {
  final numbersLine = lines.where((element) => element.length >= 2 && element[1] == '1').toList()[0];
  final cratesCount = int.parse(numbersLine[numbersLine.length - 1]);
  return List.generate(cratesCount, (index) => <String>[]);
}

Future<void> solve() async {
  await readLines("5.txt").then((lines) {
    final List<List<String>> stacks = findStacksCount(lines);
    for (var element in lines) {parseLine(stacks, element, false);}
    final finalScore = stacks.map((e) => e.last).join("");
    final List<List<String>> stacks2 = findStacksCount(lines);
    for (var element in lines) {parseLine(stacks2, element, true);}
    final finalScore2 = stacks2.map((e) => e.last).join("");
    print("Day 5, Ex1: $finalScore");
    print("Day 5, Ex2: $finalScore2");
  });
}
