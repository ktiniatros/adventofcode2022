import 'package:advent/1.dart' as first;
import 'package:advent/2.dart' as second;

void main(List<String> arguments) {
  solve();
}

Future<void> solve() async {
  await first.solve();
  await second.solve();
}
