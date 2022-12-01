import 'dart:io';

Future<String> readFile(String filePath) async {
  final basePath = Platform.script.toFilePath().split(".dart_tool").first;
  var input = await File("${basePath}assets/$filePath").readAsString();
  return input;
}

Future<List<dynamic>> readLines(String filePath) async {
  final input = await readFile(filePath);
  final list = input.split("\n");
  return list;
}

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

void solve() {
  readLines("1.txt").then((lines) {
    print("Solution1: ${sumLines(lines)}");
    print("Solution2: ${sumThreeLines(lines)}");
  });
}
