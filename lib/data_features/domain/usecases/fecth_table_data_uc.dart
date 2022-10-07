import 'package:flutter_database/data_features/data/models/single_model.dart';
import 'package:flutter_database/data_features/data/models/table_name_model.dart';
import 'package:flutter_database/data_features/domain/repository/main_repository.dart';
import 'package:flutter_database/data_features/domain/usecases/main_repo_uc.dart';

class FetchJobUseCase extends MainRepoUsecase {
  FetchJobUseCase(MainRepository mainRepository) : super(mainRepository);

  Future<List<TableName>> fetchData(String dbName) async {
    var response = await mainRepository.fetchTableName(dbName: dbName);
    return response;
  }

  Future<List<ModelsTable>> fetchTableData(
      String dbName, String tableName) async {
    var response = await mainRepository.fetchTableData(
        dbName: dbName, tableName: tableName);
    return response;
  }
}
