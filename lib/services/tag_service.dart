import 'package:strawa/domain/repositories/tag_repository.dart';

class TagService {
  final _tagRepository = TagRepository();

  Future<List<String>> getTagNames() async {
    try {
      final tagNameList = await _tagRepository.fetchTagNamesOnly();
      return tagNameList;
    }
    catch(e) {
      throw Exception("Service failed to retrieve tag names list from database: ${e.toString()}");
    }
  }
}