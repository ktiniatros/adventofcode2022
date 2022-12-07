import 'package:advent/1.dart' as first;
import 'package:advent/2.dart' as second;
import 'package:advent/3.dart' as third;
import 'package:advent/4.dart' as fourth;
import 'package:advent/5.dart' as fifth;
import 'package:advent/6.dart' as sixth;
import 'package:advent/7.dart' as seventh;

void main(List<String> arguments) {
  solve();
}

Future<void> solve() async {
  await first.solve();
  await second.solve();
  await third.solve();
  await fourth.solve();
  await fifth.solve();
  await sixth.solve();
  await seventh.solve();
}
