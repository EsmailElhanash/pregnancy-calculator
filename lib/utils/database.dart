import 'package:HamilGuide/utils/date_util.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../constants.dart';

var now = DateTime.now();

Future<void> saveData(int startDateInMS, CalendarType calendarType) async {
  var databasesPath = await getDatabasesPath();
  String path = join(databasesPath, DB_NAME);

  Database database = await openDatabase(
    path,
    version: 1,
    onCreate: (db, version) async {
      try {
        await db.execute('''
        CREATE TABLE $TABLE_NAME (id INTEGER PRIMARY KEY, $ENTRY_DATE_COLUMN TEXT, $START_DATE_IN_MS_COLUMN INTEGER, $CALENDAR_TYPE INTEGER)
        ''');
      } catch (e) {
        print(e);
      }
    },
  );

  Map<String, dynamic> data0 = {
    'id': DB_ITEM_ID,
    ENTRY_DATE_COLUMN: DateFormat('yMd').format(now),
    START_DATE_IN_MS_COLUMN: startDateInMS,
    CALENDAR_TYPE: calendarType.index
  };

  await database.transaction((txn) async {
    try {
      await txn.insert(TABLE_NAME, data0,
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      await txn.execute('''
        CREATE TABLE $TABLE_NAME (id INTEGER PRIMARY KEY, $ENTRY_DATE_COLUMN TEXT, $START_DATE_IN_MS_COLUMN INTEGER, $CALENDAR_TYPE INTEGER)
        ''');
      await txn.insert(TABLE_NAME, data0,
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  });
}

Future<List<Map<String, dynamic>>> getMyData() async {
  String path = join(await getDatabasesPath(), DB_NAME);
  Database database = await openDatabase(path);
  List<Map<String, dynamic>> list;
  try {
    await database.transaction((txn) async {
      try {
        list = await txn.query(
          TABLE_NAME,
          columns: [START_DATE_IN_MS_COLUMN, CALENDAR_TYPE],
          where: 'id=$DB_ITEM_ID',
        );
      } catch (ignored) {
        list = null;
      }
    });
  } catch (e) {
    list = null;
    print(e);
  }
  return list;
}
