import 'package:get_it/get_it.dart';
import 'package:strawa/domain/repositories/product_repository.dart';
import 'package:strawa/domain/repositories/tag_repository.dart';
import 'package:strawa/domain/repositories/chain_repository.dart';
import 'package:strawa/services/product_service.dart';
import 'package:strawa/services/tag_service.dart';
import 'package:strawa/services/chain_service.dart';

// tworzy tylko 1 instancje
final locator = GetIt.instance;
void setupLocator() {
  // Repositories
  locator.registerLazySingleton<ProductRepository>(() => ProductRepository());
  locator.registerLazySingleton<TagRepository>(() => TagRepository());
  locator.registerLazySingleton<ChainRepository>(() => ChainRepository());

  // Services
  locator.registerLazySingleton<ProductService>(() => ProductService());
  locator.registerLazySingleton<TagService>(() => TagService());
  locator.registerLazySingleton<ChainService>(() => ChainService());
}
