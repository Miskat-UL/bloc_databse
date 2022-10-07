import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_database/data_features/data/models/education_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'data_features/data/models/order_type.dart';

class Databases {
  List emloyee = [];

  Future<List<String>> tableNames(String dbName) async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "bdjobs_corporate.db");
    var exists = await databaseExists(path);

    if (!exists) {
      // print("Creating new copy from asset");

      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data =
          await rootBundle.load(join("assets", "bdjobs_corporate.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }
    var db = await openDatabase(path, readOnly: false);
    List<Map> names =
        await db.rawQuery('SELECT * FROM sqlite_master ORDER BY name;');
    List<String> tableNameList = [];
    if (names.length > 0) {
      for (int i = 0; i < names.length; i++) {
        try {
          if (names[i].toString() == 'android_metadata') {
            print('debug');
          } else {
            print('debug');
            tableNameList.add(names[i]['name'].toString());
          }
        } catch (e) {
          print('Exeption : ' + e.toString());
        }
      }
    }
    return tableNameList;
  }

  Future<List<dynamic>> getDb(String tableName) async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "bdjobs_corporate.db");
    var exists = await databaseExists(path);

    if (!exists) {
      print("Creating new copy from asset");

      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data =
          await rootBundle.load(join("assets", "bdjobs_corporate.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }
    var db = await openDatabase(path, readOnly: false);

    List<Map> list = await db.rawQuery('SELECT * FROM $tableName');
    if (tableName == "OrgTypes") {
      List<Order> orders = [];
      for (var n in list) {
        orders
            .add(Order(org_id: n['Org_Type_ID'], org_type: n['Org_Type_Name']));
      }
      return orders;
    }

    print(list);
    List<Education> empList = [];
    for (var n in list) {
      empList.add(Education(edu_level: n['EDU_LEVEL'], edu_id: n['EDU_ID']));
    }

    return empList;
    // list.map((e) => emp_list.add(Education(
    //     id: e['id'], edu_id: e['EDU_LEVEL'], edu_level: e['EDU_ID'])));
  }
}
