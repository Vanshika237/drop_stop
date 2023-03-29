import 'package:hive/hive.dart';

final hiveUtility = HiveUtility();

const String boxName = "count_box";
const String countKey = "count";

class HiveUtility {
  open() async {
    await Hive.openBox(boxName);
  }

  addCount() {
    int count = getCount();
    count++;
    Hive.box(boxName).put(countKey, count);
  }

  int getCount() {
    return Hive.box(boxName).get(countKey, defaultValue: 0);
  }
}
