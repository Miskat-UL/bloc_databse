import 'package:flutter/services.dart';
import 'package:flutter_database/data_features/data/models/education_model.dart';
import 'package:flutter_database/data_features/data/models/order_type.dart';
import 'package:flutter_database/data_features/data/models/single_model.dart';
import 'package:flutter_database/data_features/data/models/table_name_model.dart';
import 'package:flutter_database/data_features/domain/repository/main_repository.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'dart:io';

class MainRepoImp implements MainRepository {
  @override
  Future<List<TableName>> fetchTableName({required String dbName}) async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, dbName);
    var exists = await databaseExists(path);

    if (!exists) {
      // print("Creating new copy from asset");

      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", dbName));
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
    List<TableName> tableNameList = [];
    if (names.isNotEmpty) {
      for (int i = 0; i < names.length; i++) {
        try {
          if (names[i].toString() == 'android_metadata') {
            print('debug');
          } else {
            print('debug');
            tableNameList
                .add(TableName(tableName: names[i]['name'].toString()));
          }
        } catch (e) {
          print('Exeption : ' + e.toString());
        }
      }
    }
    return tableNameList;
  }

  @override
  Future<List<ModelsTable>> fetchTableData(
      {required String dbName, required String tableName}) async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, dbName);
    var exists = await databaseExists(path);

    if (!exists) {
      print("Creating new copy from asset");

      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", dbName));
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
      List<ModelsTable> tables = [];
      for (var n in list) {
        tables.add(ModelsTable(
          id: n['Org_Type_ID'],
          title: n['Org_Type_Name'],
          extra: "NO Extra Data",
        ));
      }
      return tables;
    }
    if (tableName == "CATEGORY") {
      List<ModelsTable> tables = [];
      for (var n in list) {
        tables.add(
          ModelsTable(
            id: n['CAT_ID'],
            title: n['CAT_NAME'],
            extra: n['CAT_NAME_BANGLA'],
          ),
        );
      }
      return tables;
    }
    if (tableName == "EDUCATION_LEVELS") {
      List<ModelsTable> tables = [];
      for (var n in list) {
        tables.add(
          ModelsTable(
            id: n['EDU_ID'],
            title: n['EDU_LEVEL'],
            extra: 'NO EXTRA DATA',
          ),
        );
      }
      return tables;
    }
    if (tableName == "Industries") {
      List<ModelsTable> tables = [];
      for (var n in list) {
        tables.add(
          ModelsTable(
            id: n['field1'],
            title: n['field2'],
            extra: n['field3'],
          ),
        );
      }
      return tables;
    }
    if (tableName == "LOCATIONS") {
      List<ModelsTable> tables = [];
      for (var n in list) {
        tables.add(
          ModelsTable(
            id: n['L_ID'],
            title: n['L_Name'],
            extra: n['L_NameBangla'],
          ),
        );
      }
      return tables;
    }

    // print(list);
    // List<Education> empList = [];
    // for (var n in list) {
    //   empList.add(Education(edu_level: n['EDU_LEVEL'], edu_id: n['EDU_ID']));
    // }

    // return empList;
    return [];
  }
}
