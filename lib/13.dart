import 'package:advent/common.dart';
import 'package:dartx/dartx.dart';

class PacketPair {
  PacketPair(this.firstPacket);

  List<dynamic> firstPacket;
  List<dynamic> secondPacket = [];

  @override
  String toString() {
    return '1: $firstPacket, 2: $secondPacket';
  }
}

List<dynamic> parsePacket(String packet) {
  List<dynamic> parsedPacket = [];
  if (packet.length > 2) {
    List<String> parts = packet.substring(1, packet.length - 1).split(',');
    String currentNested = '';
    for (var part in parts) {
      bool isLeftBracket = part.contains('[');
      bool isRightBracket = part.contains(']');
      if (!isLeftBracket && !isRightBracket && currentNested.isEmpty) {
        parsedPacket.add(part);
      }

      if (isLeftBracket || isRightBracket || currentNested.isNotEmpty) {
        currentNested = '$currentNested$part,';
      }

      int leftBrackets = currentNested.runes.where((element) => element == 91).length;
      int rightBrackets = currentNested.runes.where((element) => element == 93).length;
      if (currentNested.length > 1 && leftBrackets ==rightBrackets) {
        parsedPacket.add(parsePacket(currentNested.removeSuffix(',')));
        currentNested = '';
      }
    }
  }


  return parsedPacket;
}

bool? _compareIntegers(int a, int b) {
  if (a < b) {
    return true;
  } else if (a > b) {
    return false;
  }
  return null;
}

// If both values are lists, compare the first value of each list, then the second value, and so on.
// If the lists are the same length and no comparison makes a decision about the order, continue checking the next part of the input.
bool? _compareList(List<dynamic> a, List<dynamic> b) {
  bool? currentResult;
  for (var i = 0; i < b.length; i++) {
    dynamic bb = b[i];

    // If the left list runs out of items first, the inputs are in the right order.
    if (a.length == i) {
      if (currentResult == null) {
        return true;
      }
      return currentResult;
    }

    dynamic aa = a[i];

    if (bb is String && aa is String) {
      currentResult = _compareIntegers(int.parse(aa), int.parse(bb));
      if (currentResult != null) {
        return currentResult;
      }
    } else if (bb is List && aa is List) {
      currentResult = _compareList(aa, bb);
    } else if (bb is List) {
      currentResult = _compareList([aa], bb);
    } else {
      currentResult = _compareList(aa, [bb]);
    }

    if (currentResult != null) {
      return currentResult;
    }
  }
  // If the right list runs out of items first, the inputs are not in the right order.
  if (currentResult == null && b.length < a.length) {
    return false;
  }
  return currentResult;
}

List<PacketPair> _parseLines(List<String> lines) {
  List<PacketPair> packetPairs = [];
  for (var i = 0; i < lines.length; i++) {
    String line = lines[i];
    if (i % 3 == 0) {
      packetPairs.add(PacketPair(parsePacket(line)));
    }
    if (i % 3 == 1) {
      packetPairs.last.secondPacket = parsePacket(line);
    }
  }

  return packetPairs;
}

int ex2(List<PacketPair> packetPairs) {
  final dividerPackets = [[['2']], [['6']]];

  List<List<dynamic>> packets = [];
  for (var packetPair in packetPairs) {
    packets.add(packetPair.firstPacket);
    packets.add(packetPair.secondPacket);
  }
  packets.addAll(dividerPackets);

  final sortedPackets = packets.sortedWith((a, b) {
    final compareResult = _compareList(a, b)!;
    if (compareResult) {
      return -1;
    } else {
      return 1;
    }
  });

  return (sortedPackets.indexOf(dividerPackets[0]) + 1) * (sortedPackets.indexOf(dividerPackets[1]) + 1);
}

int ex1(List<PacketPair> packetPairs) {
  final pairs = packetPairs.map((e) => _compareList(e.firstPacket, e.secondPacket)).toList();
  var sum = 0;
  for (var index = 0; index < pairs.length; index++) {
    if (pairs[index] == true) {
      sum += index + 1;
    }
  }
  return sum;
}

Future<void> solve() async {
  await readLines("13.txt").then((lines) {
    final packetPairs =  _parseLines(lines);

    final finalScore1 = ex1(packetPairs);
    final finalScore2 = ex2(packetPairs);

    print("Day 13, Ex1: $finalScore1");
    print("Day 13, Ex2: $finalScore2");
  });
}