import 'package:equatable/equatable.dart';
import 'package:flutter_database/data_features/data/models/single_model.dart';
import 'package:flutter_database/data_features/data/models/table_name_model.dart';

abstract class TableState extends Equatable {
  const TableState();

  @override
  List<Object> get props => [];
}

class TableInitial extends TableState {}

class TableLoading extends TableState {}

class TableLoaded extends TableState {
  final List<TableName> tableName;
  const TableLoaded(this.tableName);
}

class TableDataLoaded extends TableState {
  final List<ModelsTable> tableData;
  const TableDataLoaded(this.tableData);
}

class TableError extends TableState {
  final String message;
  const TableError(this.message);
}

// class TableLoading extends TableState {}
