import 'dart:developer';

import 'package:musily/core/data/database/wrapped_stats_database.dart';
import 'package:musily/core/domain/presenter/app_controller.dart';
import 'package:musily/features/wrapped/data/usecases/generate_wrapped_usecase_impl.dart';
import 'package:musily/features/wrapped/presenter/controllers/wrapped/wrapped_data.dart';
import 'package:musily/features/wrapped/presenter/controllers/wrapped/wrapped_methods.dart';
import 'package:musily/features/wrapped/presenter/utils/wrapped_theme.dart';

class WrappedController extends BaseController<WrappedData, WrappedMethods> {
  final _wrappedStatsDatabase = WrappedStatsDatabase.instance;
  late final _generateWrappedUsecase = GenerateWrappedUsecaseImpl(
    wrappedStatsDatabase: _wrappedStatsDatabase,
  );

  @override
  WrappedData defineData() {
    return WrappedData();
  }

  @override
  WrappedMethods defineMethods() {
    return WrappedMethods(
      loadOrGenerateWrapped: _loadOrGenerateWrapped,
      regenerateWrapped: _regenerateWrapped,
    );
  }

  Future<void> _loadOrGenerateWrapped({int? year}) async {
    final targetYear = year ?? DateTime.now().year;

    updateData(
      data.copyWith(loading: true, error: null),
    );

    try {
      // TODO: Temporary
      await _wrappedStatsDatabase.deleteWrappedByYear(targetYear);

      final rangeStart = DateTime(targetYear, 1, 1);
      final rangeEnd = DateTime(targetYear, 12, 31, 23, 59, 59);

      final newWrapped = await _generateWrappedUsecase.exec(
        rangeStart: rangeStart,
        rangeEnd: rangeEnd,
      );

      final theme = WrappedTheme.fromSeed(newWrapped.visualSeed.hashCode);

      updateData(
        data.copyWith(
          wrapped: newWrapped,
          theme: theme,
          loading: false,
        ),
      );
    } catch (e, stackTrace) {
      log(e.toString(), stackTrace: stackTrace);
      updateData(
        data.copyWith(
          loading: false,
          error: e.toString(),
        ),
      );
      catchError(e);
    }
  }

  Future<void> _regenerateWrapped({int? year}) async {
    final targetYear = year ?? DateTime.now().year;

    updateData(
      data.copyWith(loading: true, error: null),
    );

    try {
      final rangeStart = DateTime(targetYear, 1, 1);
      final rangeEnd = DateTime(targetYear, 12, 31, 23, 59, 59);

      final newWrapped = await _generateWrappedUsecase.exec(
        rangeStart: rangeStart,
        rangeEnd: rangeEnd,
      );

      final theme = WrappedTheme.fromSeed(newWrapped.visualSeed.hashCode);

      updateData(
        data.copyWith(
          wrapped: newWrapped,
          theme: theme,
          loading: false,
        ),
      );
    } catch (e) {
      updateData(
        data.copyWith(
          loading: false,
          error: e.toString(),
        ),
      );
      catchError(e);
    }
  }
}
