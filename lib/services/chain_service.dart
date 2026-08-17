import 'package:strawa/domain/repositories/chain_repository.dart';

class ChainService {
  final _chainRepository = ChainRepository();

  Future<List<String>> getChainNames() async {
    try {
      final chainNameList = await _chainRepository.fetchChainNamesOnly();
      return chainNameList;
    }
    catch(e) {
      throw Exception("Service failed to retrieve chain names list from database: ${e.toString()}");
    }
  }

}