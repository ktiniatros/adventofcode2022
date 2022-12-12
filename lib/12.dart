import 'package:advent/common.dart';
import 'package:dartx/dartx.dart';
import 'package:equatable/equatable.dart';

class Point extends Equatable {
  Point(this.x, this.y);

  int x;
  int y;

  @override
  List<Object> get props => [x, y];

  @override
  String toString() {
    return "$x:$y";
  }
}

class PointValue {
  PointValue({
    required this.x,
    required this.y,
    required this.distance,
  });
  int x;
  int y;
  int distance;
}

final _finalPositionValue = 'z'.codeUnitAt(0) + 1;

List<dynamic> _findStartsAndPrepareGrid(List<String> lines,
    List<List<int>> heightMap, bool useA) {
  var row = 0;
  var column = 0;
  List<Point> starts = List.empty(growable: true);
  for (var line in lines) {
    for (var char in line.characters) {
      heightMap[row][column] = char.codeUnitAt(0);
      final startingCondition = useA ? (char == 'S' || char == 'a') : (char == 'S');
      if (startingCondition) {
        starts.add(Point(row, column));
        heightMap[row][column] = 'a'.codeUnitAt(0);
      }
      if (char == 'E') {
        heightMap[row][column] = _finalPositionValue;
      }
      column += 1;
    }
    column = 0;
    row += 1;
  }
  return [starts, heightMap];
}

int _parseLines(List<String> lines, List<List<bool>> visitedSpots,
    List<List<int>> heightMap) {
  List<dynamic> setup = _findStartsAndPrepareGrid(lines, heightMap, false);
  List<Point> starts = setup[0];
  heightMap = setup[1];

  Point start = starts[0];
  List<PointValue> paths = List.empty(growable: true);
  final initial = PointValue(x: start.x, y: start.y, distance: 0);
  visitedSpots[start.x][start.y] = true;
  paths.add(initial);
  return _minDistance(paths, visitedSpots, heightMap);
}

int _parseLines2(List<String> lines, List<List<bool>> visitedSpots,
    List<List<int>> heightMap) {
  List<dynamic> setup = _findStartsAndPrepareGrid(lines, heightMap, true);
  List<Point> starts = setup[0];
  heightMap = setup[1];

  return starts.map((start) {
    List<PointValue> paths = List.empty(growable: true);
    final initial = PointValue(x: start.x, y: start.y, distance: 0);
    List<List<bool>> visitedSpotsNew = List.generate(visitedSpots.length, (_) => List.generate(visitedSpots[0].length, (_) => false));
    visitedSpotsNew[start.x][start.y] = true;
    paths.add(initial);
    return _minDistance(paths, visitedSpotsNew, heightMap);
  }).toList().where((element) => element > -1).sorted().first;

}

int _minDistance(List<PointValue> paths, List<List<bool>> visitedSpots, List<List<int>> heightMap) {
  final N = heightMap.length;
  final M = heightMap[0].length;
  while (paths.isNotEmpty) {
    var p = paths[0];
    paths.removeAt(0);

    // Destination found;
    if (heightMap[p.x][p.y] == _finalPositionValue) {
      return p.distance;
    }

    // moving up
    if (p.x - 1 >= 0 &&
        heightMap[p.x - 1][p.y] - heightMap[p.x][p.y] < 2 &&
        visitedSpots[p.x - 1][p.y] == false) {
      paths.add(PointValue(x: p.x - 1, y: p.y, distance: p.distance + 1));
      visitedSpots[p.x - 1][p.y] = true;
    }

    // moving down
    if (p.x + 1 < N &&
        heightMap[p.x + 1][p.y] - heightMap[p.x][p.y] < 2 &&
        visitedSpots[p.x + 1][p.y] == false) {
      paths.add(PointValue(x: p.x + 1, y: p.y, distance: p.distance + 1));
      visitedSpots[p.x + 1][p.y] = true;
    }

    // moving left
    if (p.y - 1 >= 0 &&
        heightMap[p.x][p.y - 1] - heightMap[p.x][p.y] < 2 &&
        visitedSpots[p.x][p.y - 1] == false) {
      paths.add(PointValue(x: p.x, y: p.y - 1, distance: p.distance + 1));
      visitedSpots[p.x][p.y - 1] = true;
    }

    // moving right
    if (p.y + 1 < M &&
        heightMap[p.x][p.y + 1] - heightMap[p.x][p.y] < 2 &&
        visitedSpots[p.x][p.y + 1] == false) {
      paths.add(PointValue(x: p.x, y: p.y + 1, distance: p.distance + 1));
      visitedSpots[p.x][p.y + 1] = true;
    }
  }
  return -1;
}

Future<void> solve() async {
  await readLines("12.txt").then((lines) {
    int columnsLength = lines.length;
    int rowsLength = lines.first.length;

    final finalScore = _parseLines(lines, List.generate(
        columnsLength, (_) => List.generate(rowsLength, (_) => false)), List.generate(
    columnsLength, (_) => List.generate(rowsLength, (_) => 0)));

    final finalScore2 = _parseLines2(lines, List.generate(
        columnsLength, (_) => List.generate(rowsLength, (_) => false)), List.generate(
        columnsLength, (_) => List.generate(rowsLength, (_) => 0)));

    print("Day 12, Ex1: $finalScore");
    print("Day 12, Ex2: $finalScore2");
  });
}
