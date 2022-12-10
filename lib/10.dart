import 'package:advent/common.dart';
import 'package:dartx/dartx.dart';

int parseCommand(String command) {
  if (command.startsWith("addx")) {
    return int.parse(command.split(" ")[1]);
  }
  return 0;
}

final interestingCycles = [20, 60, 100, 140, 180, 220];

int checkCycle(int cycle, int X) {
  final index = interestingCycles.indexOf(cycle);
  if (index > -1) {
    return cycle * X;
  }
  return 0;
}

int parseLines(List<String> lines) {
  var cycles = 0;
  var X = 1;
  var signalStrength = 0;
  for (var element in lines) {
      int addValue = parseCommand(element);
      // print('newAddvalue: $addValue');
      if (addValue == 0) {
        cycles += 1;
        signalStrength += checkCycle(cycles, X);
      } else {
        cycles += 1;
        signalStrength += checkCycle(cycles, X);
        cycles += 1;
        signalStrength += checkCycle(cycles, X);
        X += addValue;
      }
  }
  return signalStrength;
}

List<String> screen = List.generate(40 * 6, (index) => '.');

void checkScreen(List<int> sprite, int position) {
  if (sprite.contains(position % 40)) {
    screen[position] = '#';
  }
}

void parseLines2(List<String> lines) {
  var cycles = 0;
  var X = 1;
  var sprite = [0, 1, 2];
  for (var element in lines) {
    int addValue = parseCommand(element);
    if (addValue == 0) {
      cycles += 1;
      checkScreen(sprite, cycles - 1);
    } else {
      cycles += 1;
      checkScreen(sprite, cycles - 1);
      cycles += 1;
      checkScreen(sprite, cycles - 1);
      X += addValue;
      sprite = [X-1, X, X+1];
    }
  }
}

Future<void> solve() async {
  await readLines("10.txt").then((lines) {
    final finalScore = parseLines(lines);
    print("Day 10, Ex1: $finalScore");
    parseLines2(lines);
    final screenLines = screen.chunked(40).toList();
    for (var element in screenLines) {
      print(element.reduce((value, element) => value + element));
    }
  });
}