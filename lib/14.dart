import 'package:advent/common.dart';
import 'package:dartx/dartx.dart';

class Point {
  const Point(this.x, this.y);
  final int x;
  final int y;

  @override
  String toString() {
    return '$x:$y';
  }

  Point nextPointBelow() => Point(x + 1, y);
  Point nextPointLeftBelow() => Point(x + 1, y - 1);
  Point nextPointRightBelow() => Point(x + 1, y + 1);
}

String startMark = '#';
void _fillPath(List<List<String>> state, Point start, Point end) {
  if (end.y != start.y) {
    int x = start.x;
    List<int> path = [end.y, start.y].sorted();
    for (int y = path[0]; y <= path[1]; y++) {
      state[x][y] = startMark;
      if (startMark == 'x') {
        startMark = '#';
      }
    }
  } else if (end.x != start.x) {
    int y = start.y;
    List<int> path = [start.x, end.x].sorted();
    for (int x = path[0]; x <= path[1]; x++) {
      state[x][y] = startMark;
      if (startMark == 'x') {
        startMark = '#';
      }
    }
  }
}

List<List<String>> _setupRocks(int rows, int columns, List<List<Point>> points, bool addFloor) {
  List<List<String>> state = List.generate(rows + 2, (indexY) => List.generate(columns + 200 + _normalizeFactor, (indexX) {
    if (indexY == rows + 1 && addFloor) {
      return '#';
    } else {
      return '.';
    }
  }));

  for (List<Point> path in points) {
    for (int i = 0; i < path.length - 1; i++) {
      _fillPath(state, path[i], path[i + 1]);
    }
  }

  return state;
}

int _normalizeFactor = 0;
List<List<String>> _parseLines(List<String> lines, bool addFloor) {
  final paths = lines.map((e) => e.split(' -> ')).toList();
  List<List<Point>> points = paths.map((coordinates) {
    final points = coordinates.map((e) {
      final coordinate = e.split(',');
      return Point(int.parse(coordinate[1]), int.parse(coordinate[0]));
    });
    return points.toList();
  }).toList();
  List<int> rows = points.flatten().map((e) => e.x).toList().sorted();
  List<int> columns = points.flatten().map((e) => e.y).toList().sorted();

  // calculated based on how far to left or right (compared to the initial spot) a sand can end up
  int secondPartAdjustment = rows.last + 1;
  _normalizeFactor = columns.first - secondPartAdjustment;

  List<List<Point>> normalizedPoints = points.map((e) => e.map((p) => Point(p.x , p.y - _normalizeFactor)).toList()).toList();

  return _setupRocks(rows.last + 1, columns.last + 1 - columns.first,  normalizedPoints, addFloor);
}

bool _isAir(List<List<String>> initialState, Point point) => initialState[point.x][point.y] == '.';
bool _isAbyss(List<List<String>> initialState, Point point) =>
    point.y < 0 || point.y >= initialState[0].length || point.x >= initialState.length;

bool _nextSandSpot(List<List<String>> initialState, Point currentPoint) {
  Point pointBelow = currentPoint.nextPointBelow();
  Point pointLeftBelow = currentPoint.nextPointLeftBelow();
  Point pointRightBelow = currentPoint.nextPointRightBelow();

  if (_isAbyss(initialState, pointBelow)) {
    return false;
  }

  if (_isAir(initialState, pointBelow)) {
    return _nextSandSpot(initialState, pointBelow);
  }

  if (_isAbyss(initialState, pointLeftBelow)) {
    return false;
  }

  if (_isAir(initialState, pointLeftBelow)) {
    return _nextSandSpot(initialState, pointLeftBelow);
  }

  if (_isAbyss(initialState, pointRightBelow)) {
    return false;
  }

  if (_isAir(initialState, pointRightBelow)) {
    return _nextSandSpot(initialState, pointRightBelow);
  }

  initialState[currentPoint.x][currentPoint.y] = 'o';
  return true;
}

Point _nextSandSpotPoint(List<List<String>> initialState, Point currentPoint) {
  Point pointBelow = currentPoint.nextPointBelow();
  Point pointLeftBelow = currentPoint.nextPointLeftBelow();
  Point pointRightBelow = currentPoint.nextPointRightBelow();

  if (_isAir(initialState, pointBelow)) {
    return _nextSandSpotPoint(initialState, pointBelow);
  }

  if (_isAir(initialState, pointLeftBelow)) {
    return _nextSandSpotPoint(initialState, pointLeftBelow);
  }

  if (_isAir(initialState, pointRightBelow)) {
    return _nextSandSpotPoint(initialState, pointRightBelow);
  }

  return currentPoint;
}

int fillSandParticles(List<List<String>> state) {
  final initialPoint = Point(0, 500 - _normalizeFactor);
  state[initialPoint.x][initialPoint.y] = '+';
  Point currentPoint = Point(initialPoint.x, initialPoint.y);
  while(state[initialPoint.x][initialPoint.y] != 'o') {
    Point nextSandPoint = _nextSandSpotPoint(state, currentPoint);
    state[nextSandPoint.x][nextSandPoint.y] = 'o';
  }
  return state.flatten().where((element) => element == 'o').length;
}

int countSandParticles(List<List<String>> state) {
  final initialPoint = Point(0, 500 - _normalizeFactor);
  state[initialPoint.x][initialPoint.y] = '+';
  bool abyss = false;
  int sandParticles = 0;
  while(!abyss) {
    bool next = _nextSandSpot(state, initialPoint);
    if (!next) {
      abyss = true;
    } else {
      sandParticles += 1;
    }
  }
  return sandParticles;
}

Future<void> solve() async {
  await readLines("14.txt").then((lines) {
    final finalScore = countSandParticles(_parseLines(lines, false));
    final finalScore2 = fillSandParticles(_parseLines(lines, true));

    print("Day 14, Ex1: $finalScore");
    print("Day 14, Ex2: $finalScore2");
  });
}