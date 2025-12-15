import 'package:musily/features/wrapped/domain/entities/wrapped_entity.dart';

abstract class GenerateWrappedUsecase {
  Future<WrappedEntity> exec({
    required DateTime rangeStart,
    required DateTime rangeEnd,
    int topItemsLimit = 5,
  });
}
