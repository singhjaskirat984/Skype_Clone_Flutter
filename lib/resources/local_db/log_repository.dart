import 'package:sclone/models/log.dart';
import 'package:sclone/resources/local_db/hive_methods.dart';
import 'package:meta/meta.dart';
import 'package:sclone/resources/local_db/sqlite_methods.dart';

class LogRepository {
  static var dbObject;
  static bool isHive;

  static init({@required bool isHive, @required String dbName}) {
    dbObject = isHive ? HiveMethods() : SqliteMethods();
    dbObject.openDb(dbName);
    dbObject.init();
  }

  static addLogs(Log log) => dbObject.addLogs(log);

  static deleteLogs(int logId) => dbObject.deleteLogs(logId);

  static getLogs() => dbObject.getLogs();

  static close() => dbObject.close();
}