import 'package:musily/core/data/database/wrapped_stats_database.dart';
import 'package:musily/features/wrapped/domain/entities/wrapped_entity.dart';
import 'package:musily/features/wrapped/domain/usecases/get_wrapped_usecase.dart';

class GetWrappedUsecaseImpl implements GetWrappedUsecase {
  final _wrappedStatsDatabase = WrappedStatsDatabase.instance;

  @override
  Future<WrappedEntity?> exec({required int year}) async {
    return await _wrappedStatsDatabase.getWrappedByYear(year);
  }
}
