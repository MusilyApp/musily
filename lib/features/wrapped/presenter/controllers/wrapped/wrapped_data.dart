import 'package:musily/core/domain/presenter/app_controller.dart';
import 'package:musily/features/wrapped/domain/entities/wrapped_entity.dart';
import 'package:musily/features/wrapped/presenter/utils/wrapped_theme.dart';

class WrappedData extends BaseControllerData {
  final WrappedEntity? wrapped;
  final bool loading;
  final String? error;
  final WrappedTheme? theme;

  WrappedData({
    this.wrapped,
    this.loading = false,
    this.error,
    this.theme,
  });

  @override
  WrappedData copyWith({
    WrappedEntity? wrapped,
    bool? loading,
    String? error,
    WrappedTheme? theme,
  }) {
    return WrappedData(
      wrapped: wrapped ?? this.wrapped,
      loading: loading ?? this.loading,
      error: error ?? this.error,
      theme: theme ?? this.theme,
    );
  }
}
