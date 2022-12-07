import 'package:advent/common.dart';

class DirectoryContents {
  const DirectoryContents({
  required this.folders,
  required this.filesSize,
});

  final List<String> folders;
  final int filesSize;

  DirectoryContents add(DirectoryContents directoryContents) {
    return DirectoryContents(
      folders: folders + directoryContents.folders,
      filesSize: filesSize + directoryContents.filesSize,
    );
  }

  DirectoryContents addFolder(String folder) {
    return DirectoryContents(
      folders: folders + [folder],
      filesSize: filesSize,
    );
  }

  DirectoryContents addFile(int size) {
    return DirectoryContents(folders: folders, filesSize: filesSize + size);
  }

  DirectoryContents folderSizeFound(String folder, int folderSize) {
    folders.remove(folder);
    return DirectoryContents(folders: folders, filesSize: filesSize + folderSize);
  }
}

Map<String, DirectoryContents> directoryContents = {};
Map<String, int> directorySize = {};

bool isCommand(String line) => line.startsWith("\$");
bool changeDirectory(String line) => line.startsWith("\$ cd");
bool listDirectory(String line) => line.startsWith("\$ ls");

const totalSize = 70000000;
const minimumSizeForUpdate = 30000000;

void parseLines(List<String> lines) {
  var currentPath = "start";
  for (var i = 1; i < lines.length; i++) {
    final line = lines[i];

    if (isCommand(line)) {
      if (listDirectory(line)) {
      } else if (changeDirectory(line)) {
        if (line.contains("..")) {
          final subPaths = currentPath.split("/");
          currentPath = subPaths.sublist(0, subPaths.length - 1).join("/");
        } else {
          final newSubPath = line.split(" ").last;
          currentPath = "$currentPath/$newSubPath";
        }
      }
    } else {
      if (!directoryContents.containsKey(currentPath)) {
        directoryContents[currentPath] = DirectoryContents(folders: [], filesSize: 0);
      }
      final parsedLine = line.split(" ");
      if (parsedLine[0] == 'dir') {
        directoryContents[currentPath] = directoryContents[currentPath]!.addFolder("$currentPath/${parsedLine.last}");
      } else {
        directoryContents[currentPath] = directoryContents[currentPath]!.addFile(int.parse(parsedLine[0]));
      }
    }
  }
}

int countFolderSizes() {
  final limit = 100000;
  var count = 0;
  directoryContents.forEach((key, value) {
    Map<String, DirectoryContents> directoryContentsCopy = Map<String, DirectoryContents>.from(directoryContents);
    directoryContentsCopy.removeWhere((keyCopy, value) => !keyCopy.contains(key));
    var foldersCount = 0;
    if (directoryContentsCopy.isNotEmpty) {
      final foldersSizes = directoryContentsCopy.values.map((e) => e.filesSize).reduce((value, element) => value + element);
      foldersCount += foldersSizes;
    }

    final folderSize = foldersCount;
    if (folderSize < limit) {
      count += folderSize;
    }
    directorySize[key] = folderSize;

  });
  return count;
}

int directoryToDeleteSize() {
  final sizeLeft = totalSize - directorySize['start']!;
  final sizeNeeded = minimumSizeForUpdate - sizeLeft;

  directorySize.removeWhere((key, value) => value < sizeNeeded);
  final sizes = directorySize.values.toList();

  sizes.sort((a, b) => a - b);

  return sizes[0];
}

Future<void> solve() async {
  await readLines("7.txt").then((lines) {
    parseLines(lines);
    final finalScore = countFolderSizes();

    final finalScore2 = directoryToDeleteSize();
    print("Day 7, Ex1: $finalScore");
    print("Day 7, Ex2: $finalScore2");
  });
}