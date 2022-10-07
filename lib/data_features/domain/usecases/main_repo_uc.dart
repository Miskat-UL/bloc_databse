import 'package:flutter_database/data_features/domain/repository/main_repository.dart';

abstract class MainRepoUsecase {
  final MainRepository mainRepository;
  MainRepoUsecase(this.mainRepository);
}
