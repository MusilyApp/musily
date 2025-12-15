import 'package:musily/features/wrapped/domain/entities/wrapped_entity.dart';

abstract class GetWrappedUsecase {
  Future<WrappedEntity?> exec({required int year});
}
