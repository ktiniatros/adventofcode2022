import 'package:equatable/equatable.dart';

class Point extends Equatable {
  const Point(this.x, this.y);
  final int x;
  final int y;


  @override
  List<Object> get props => [x, y];

  @override
  String toString() {
    return '$x:$y';
  }

  Point nextPointBelow() => Point(x + 1, y);
  Point nextPointLeftBelow() => Point(x + 1, y - 1);
  Point nextPointRightBelow() => Point(x + 1, y + 1);
}
