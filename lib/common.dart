import 'dart:io';

Future<String> readFile(String filePath) async {
  final basePath = Platform.script.toFilePath().split(".dart_tool").first;
  var input = await File("${basePath}assets/$filePath").readAsString();
  return input;
}

Future<List<String>> readLines(String filePath) async {
  final input = await readFile(filePath);
  final list = input.split("\n");
  return list;
}