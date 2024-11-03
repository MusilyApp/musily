import 'package:musily/features/_sections_module/domain/entities/section_entity.dart';

abstract class GetSectionsUsecase {
  Future<List<HomeSectionEntity>> exec();
}
