import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_database/data_features/data/models/single_model.dart';
import 'package:flutter_database/data_features/data/repository/main_repository_imp.dart';
import 'package:flutter_database/data_features/domain/usecases/fecth_table_data_uc.dart';
import 'package:flutter_database/data_features/presentation/bloc/table_event.dart';
import 'package:flutter_database/data_features/presentation/bloc/table_state.dart';

class TableBloc extends Bloc<TableEvent, TableState> {
  TableBloc() : super(TableInitial()) {
    final FetchJobUseCase fetchJobData = FetchJobUseCase(MainRepoImp());

    on<GetTableName>((event, emit) async {
      final tableNames = await fetchJobData.fetchData('bdjobs_corporate.db');

      try {
        emit(TableLoading());

        emit(TableLoaded(tableNames));
      } catch (e) {
        emit(const TableError('Error Fetching Table Name'));
      }
    });
    on<GetAlldata>((event, emit) async {
      final data = await fetchJobData.fetchTableData(
          'bdjobs_corporate.db', event.tableName);
      try {
        emit(TableLoading());

        emit(TableDataLoaded(data));
      } catch (e) {
        emit(
          const TableError('Error Fetching Table Name'),
        );
      }
    });
  }
}
