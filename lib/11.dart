import 'package:advent/common.dart';
import 'package:dartx/dartx.dart';

List<List<int>> _monkeyItemWorryLevels = List.empty(growable: true);
List<int> _monkeyActivity = List.empty(growable: true);
List<int> _divisors = List.empty(growable: true);
int _lcm = 0;
var _isPart1 = true;

var _currentMonkeyNumber = 0;

void _parseMonkey(String line) {
  _currentMonkeyNumber = int.parse(line.split(' ').last.replaceAll(':', ''));
  if (_monkeyItemWorryLevels.length == _currentMonkeyNumber) {
    _monkeyItemWorryLevels.add(List.empty(growable: true));
  }
  if (_monkeyActivity.length == _currentMonkeyNumber) {
    _monkeyActivity.add(0);
  }
}

void _parseStartingItems(String line) {
  final lineParts = line.replaceAll(',', '').split(' ');
  final items = lineParts.sublist(4, lineParts.length).map((e) => (int.parse(e)));
  _monkeyItemWorryLevels[_currentMonkeyNumber].addAll(items);

}

void _parseOperation(String line) {
  final lineParts = line.split(' ');
  final operation = lineParts[lineParts.length - 2];
  for (var i = 0; i < _monkeyItemWorryLevels[_currentMonkeyNumber].length; i++) {
    var operationNumber = 0;
    if (lineParts.last.contains('old')) {
      operationNumber = _monkeyItemWorryLevels[_currentMonkeyNumber][i];
    } else {
      operationNumber = int.parse(lineParts.last);
    }
    _monkeyActivity[_currentMonkeyNumber] += 1;
    var newLevel = 0;
    switch (operation) {
      case '*':
        newLevel = _monkeyItemWorryLevels[_currentMonkeyNumber][i] * operationNumber;
        break;
      case '+':
        newLevel = _monkeyItemWorryLevels[_currentMonkeyNumber][i] + operationNumber;
        break;
    }

    if (_isPart1) {
      newLevel = (newLevel / 3).floor();
    }
    _monkeyItemWorryLevels[_currentMonkeyNumber][i] = newLevel;
  }
}

var _currentDivisionNumber = 1;
var _nextMonkeys = [0, 0];
void _parseDivision(String line) {
  _currentDivisionNumber = int.parse(line.split(' ').last);
}

void _parseNextMonkeys(String line) {
  if (line.contains('true')) {
    _nextMonkeys[0] = int.parse(line.split(' ').last);
  }
  if (line.contains('false')) {
    _nextMonkeys[1] = int.parse(line.split(' ').last);
    _sendItems();
    _currentMonkeyNumber += 1;
  }
}

void _sendItems() {
  for (var element in _monkeyItemWorryLevels[_currentMonkeyNumber]) {
    var finalElement = element;
    if (element > _lcm * 2) {
      finalElement = _lcm + (element%_lcm);
    }
    if ((finalElement % _currentDivisionNumber) == 0) {
      _monkeyItemWorryLevels[_nextMonkeys[0]].add(finalElement);
    } else {
      _monkeyItemWorryLevels[_nextMonkeys[1]].add(finalElement);
    }
  }
  _monkeyItemWorryLevels[_currentMonkeyNumber] = List.empty(growable: true);
}

void _parseMonkeyItems(String line) {
  if (line.startsWith('Monkey')) {
    _parseMonkey(line);
  }

  if (line.startsWith('  Starting items')) {
    _parseStartingItems(line);
  }

  if (line.contains('divisible')) {
    int divisor = int.parse(line.split(' ').last);
    _divisors.add(divisor);
  }
}

void _parseMonkeyOperations(String line) {
  if (line.startsWith('  Operation')) {
    _parseOperation(line);
  }

  if (line.startsWith('  Test')) {
    _parseDivision(line);
  }

  if (line.startsWith('    If')) {
    _parseNextMonkeys(line);
  }
}

int parseLines(List<String> lines, int rounds) {
  for (var element in lines) {
    _parseMonkeyItems(element);
  }
  _lcm = _divisors.reduce((value, element) => value * element);
  for (var i = 0; i < rounds; i++) {
    _currentMonkeyNumber = 0;
    for (var element in lines) {
      _parseMonkeyOperations(element);
    }
  }
  final sorted = _monkeyActivity.sortedDescending();
  return sorted[0] * sorted[1];
}

Future<void> solve() async {
  await readLines("11.txt").then((lines) {
    final finalScore = parseLines(lines.where((element) => element.isNotEmpty).toList(), 20);
    _isPart1 = false;
    _monkeyItemWorryLevels = List.empty(growable: true);
    _monkeyActivity = List.empty(growable: true);
    _divisors = List.empty(growable: true);
    final finalScore2 = parseLines(lines.where((element) => element.isNotEmpty).toList(), 10000);

    print("Day 11, Ex1: $finalScore");
    print("Day 11, Ex2: $finalScore2");
  });
}