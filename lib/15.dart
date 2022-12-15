import 'package:advent/common.dart';
import 'package:dartx/dartx.dart';

import 'point.dart';

List<Point> _sensors = [];
List<Point> _beacons = [];
List<int> _distances = [];
List<SensorDistance> _sensorDistances = [];

class SensorDistance {
  SensorDistance(this.sensor, this.distance);

  final Point sensor;
  final int distance;
}

Point _parseCoordinates(String line) {
  List<String> parts = line.split(',');
  String xPart = parts[0].split('=').last;
  String yPart = parts[1].split('=').last;
  return Point(int.parse(xPart), int.parse(yPart));
}

void _parseLines2(List<String> lines) {
  for (String line in lines) {
    List<String> parts = line.split(':');
    _sensors.add(_parseCoordinates(parts[0]));
    _beacons.add(_parseCoordinates(parts[1]));
    _distances.add(_Distance(
        _sensors.last.x, _sensors.last.y, _beacons.last.x, _beacons.last.y));
    _sensorDistances.add(SensorDistance(_sensors.last, _distances.last));
  }
}

int _Distance(int x, int y, int x2, int y2) {
  return (x - x2).abs() + (y - y2).abs();
}

int _y = _sensors.length == 14 ? 20 : 2000000;
int _maxSize = _sensors.length == 14 ? 20 : 4000000;
List<List<int>> _ranges = [];

List<int> _intersect(
    int x1, int y1, int x2, int y2, int x3, int y3, int x4, int y4) {
  int denominator = (y4 - y3) * (x2 - x1) - (x4 - x3) * (y2 - y1);
  double ua = 0;
  if (denominator != 0) {
    ua = ((x4 - x3) * (y1 - y3) - (y4 - y3) * (x1 - x3)) / denominator;
  }
  double x = x1 + ua * (x2 - x1);
  double y = y1 + ua * (y2 - y1);
  return [x.floor(), y.floor()];
}

List<List<List<int>>> _diamonds = [];

int _part2() {
  for (int i = 0; i < _diamonds.length; i++) {
    List<List<int>> d1 = _diamonds[i];
    for (int j = i + 1; j < _diamonds.length; j++) {
      List<List<int>> d2 = _diamonds[j];
      for (int s1 = 0; s1 < 4; s1++) {
        for (int s2 = 0; s2 < 4; s2++) {
          List<int> intersection = _intersect(
              d1[s1][0],
              d1[s1][1],
              d1[(s1 + 1) % 4][0],
              d1[(s1 + 1) % 4][1],
              d2[s2][0],
              d2[s2][1],
              d2[(s2 + 1) % 4][0],
              d2[(s2 + 1) % 4][1]);

          int xi = intersection[0];
          int yi = intersection[1];
          if (xi >= 0 &&
              xi <= _maxSize &&
              yi >= 0 &&
              yi <= _maxSize &&
              _sensorDistances.every((s) =>
                  _Distance(s.sensor.x, s.sensor.y, xi, yi) > s.distance)) {
            return xi * 4000000 + yi;
          }
        }
      }
    }
  }
  return 0;
}

Future<void> solve() async {
  await readLines("15.txt").then((lines) {
    _parseLines2(lines);
    _sensors.forEachIndexed((sensor, index) {
      int dy = _distances[index] - (_y - sensor.y).abs();
      if (dy > 0) {
        _ranges.add([sensor.x - dy, sensor.x + dy]);
      }

      int d = _distances[index] + 1;
      List<List<int>> diamond = [];
      diamond.add([sensor.x + d, sensor.y]);
      diamond.add([sensor.x, sensor.y + d]);
      diamond.add([sensor.x - d, sensor.y]);
      diamond.add([sensor.x, sensor.y - _y]);
      _diamonds.add(diamond);
    });

    List<int> finalRanges = _ranges.flatten().sorted();

    int finalScore = (finalRanges.first - finalRanges.last).abs();
    int finalScore2 = _part2();

    print("Day 15, Ex1: $finalScore");
    print("Day 15, Ex2: $finalScore2");
  });
}
