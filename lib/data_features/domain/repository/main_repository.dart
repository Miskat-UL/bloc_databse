import 'package:flutter_database/data_features/data/models/single_model.dart';
import 'package:flutter_database/data_features/data/models/table_name_model.dart';

abstract class MainRepository {
  Future<List<TableName>> fetchTableName({required String dbName});
  Future<List<ModelsTable>> fetchTableData(
      {required String dbName, required String tableName});
}
