import 'package:advent/common.dart';
import 'package:dartx/dartx.dart';

late List<List<int>> trees;

var treesColumnsParsingIndex = -1;
late List<List<int>> treesColumns;

List<int> parseLine(String line) {
  var index = -1;
  treesColumnsParsingIndex += 1;
  return line.split('').map((e) {
    int number = int.parse(e);
    index += 1;
    treesColumns[index][treesColumnsParsingIndex] = number;
    return number;
  }).toList();
}

bool isVisible(int x, int y) {
  if (x == 0 || y == 0 || x == trees[0].length - 1 || y == trees.length - 1) {
    return true;
  }
  final treeHeight = trees[x][y];
  final treesLeft = trees[x].sublist(0, y);
  final treesRight = trees[x].sublist(y + 1, trees[x].length);

  final treesTop = treesColumns[y].sublist(0, x);
  final treesBottom = treesColumns[y].sublist(x + 1, trees[y].length);

  return treesLeft.all((element) => element < treeHeight) ||
      treesRight.all((element) => element < treeHeight) ||
      treesTop.all((element) => element < treeHeight) ||
      treesBottom.all((element) => element < treeHeight);
}

int scoreEx1() {
  int visibleTrees = 0;
  for (var i = 0; i < trees.length; i++) {
    final treeRow = trees[i];
    for (var j = 0; j < treeRow.length; j++) {
      final tree = treeRow[j];
      if (isVisible(i, j)) {
        visibleTrees += 1;
      }
    }
  }
  return visibleTrees;
}

int scenicScore(int x, int y) {
  if (x == 0 || y == 0 || x == trees[0].length - 1 || y == trees.length - 1) {
    return 0;
  }
  final treeHeight = trees[x][y];
  final treesLeft = trees[x].sublist(0, y);
  final treesRight = trees[x].sublist(y + 1, trees[x].length);

  final treesTop = treesColumns[y].sublist(0, x);
  final treesBottom = treesColumns[y].sublist(x + 1, trees[y].length);

  var leftVisibleTreesCount = 0;
  var rightVisibleTreesCount = 0;
  var topVisibleTreesCount = 0;
  var bottomVisibleTreesCount = 0;

  for (var element in treesLeft.reversed) {
    leftVisibleTreesCount += 1;
    if (element >= treeHeight) {
      break;
    }
  }

  for (var element in treesRight) {
    rightVisibleTreesCount += 1;
    if (element >= treeHeight) {
      break;
    }
  }

  for (var element in treesTop.reversed) {
    topVisibleTreesCount += 1;
    if (element >= treeHeight) {
      break;
    }
  }

  for (var element in treesBottom) {
    bottomVisibleTreesCount += 1;
    if (element >= treeHeight) {
      break;
    }
  }
  return leftVisibleTreesCount * rightVisibleTreesCount * topVisibleTreesCount * bottomVisibleTreesCount;
}

int scoreEx2() {
  final scenicScores = trees.mapIndexed((index, p1) => p1.mapIndexed((index2, p2) => scenicScore(index, index2)).toList()).toList();
  return scenicScores.flatten().sorted().last;
}

Future<void> solve() async {
  await readLines("8.txt").then((lines) {
    treesColumns = List.generate(
        lines[0].length, (index) => List.generate(lines.length, (_) => 0));
    trees = List.generate(lines.length, (index) => parseLine(lines[index]));
    final finalScore = scoreEx1();

    final finalScore2 = scoreEx2();
    print("Day 8, Ex1: $finalScore");
    print("Day 8, Ex2: $finalScore2");
  });
}
