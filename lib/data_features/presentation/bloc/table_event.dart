import 'package:equatable/equatable.dart';

abstract class TableEvent extends Equatable {
  const TableEvent();

  @override
  List<Object> get props => [];
}

class GetTableName extends TableEvent {}

// class GetTableData extends TableEvent {}
class GetAlldata extends TableEvent {
  String tableName;
  GetAlldata(this.tableName);
}

// class GetCategoryData extends TableEvent {}

// class GetEducationData extends TableEvent {}

// class GetIndustryData extends TableEvent {}

// class GetLocationData extends TableEvent {}
