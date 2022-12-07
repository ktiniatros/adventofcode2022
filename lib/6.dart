import 'package:advent/common.dart';

int findMarker(String signal, int packetSize) {
  final runes = signal.runes.toList();
  for (var i = packetSize - 1; i < runes.length; i++) {
    if (Set.from(runes.sublist(i - 1, i + packetSize - 1)).length == packetSize) {
      return i + packetSize - 1;
    }
  }
  return 0;
}

Future<void> solve() async {
  await readLines("6.txt").then((lines) {
    final signal = lines[0];
    final finalScore = findMarker(signal, 4);
    final finalScore2 = findMarker(signal, 14);
    print("Day 6, Ex1: $finalScore");
    print("Day 6, Ex2: $finalScore2");
  });
}