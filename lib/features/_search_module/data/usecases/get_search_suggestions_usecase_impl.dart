import 'package:musily/features/_search_module/domain/repositories/search_repository.dart';
import 'package:musily/features/_search_module/domain/usecases/get_search_suggestions_usecase.dart';

class GetSearchSuggestionsUsecaseImpl implements GetSearchSuggestionsUsecase {
  final SearchRepository searchRepository;

  GetSearchSuggestionsUsecaseImpl({
    required this.searchRepository,
  });

  @override
  Future<List<String>> exec(String query) async {
    final suggestions = await searchRepository.getSearchSuggestions(query);
    return suggestions;
  }
}
