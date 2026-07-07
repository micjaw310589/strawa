import 'package:strawa/domain/entities/chain.dart';

abstract class ChainRepository {
  Future<List<Chain?>> getAllChains();
  Future<Chain?> getChainById(String id);
  Future<void> createChain(Chain chain);
  Future<void> updateChain(Chain chain);
  Future<void> deleteChain(String id);
}