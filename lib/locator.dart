import 'package:get_it/get_it.dart';
import 'package:strawa/domain/repositories/product_repository.dart';
import 'package:strawa/domain/repositories/tag_repository.dart';
import 'package:strawa/domain/repositories/chain_repository.dart';
import 'package:strawa/domain/repositories/osm_restaurant_repository.dart';
import 'package:strawa/presentation/nearby_screen/nearby_screen_viewmodel.dart';
import 'package:strawa/services/product_service.dart';
import 'package:strawa/services/tag_service.dart';
import 'package:strawa/services/chain_service.dart';
import 'package:strawa/presentation/todays_strawa_screen/strawa_day_screen_viewmodel.dart';
import 'package:strawa/services/location_service.dart';
import 'package:strawa/services/osm_restaurant_service.dart';
import 'package:strawa/presentation/widgets/nav_bar_viewmodel.dart';

final locator = GetIt.instance;

void setupLocator() {
  // Presentation
  locator.registerLazySingleton<NavBarViewModel>(() => NavBarViewModel());
  locator.registerLazySingleton<NearbyScreenViewModel>(() => NearbyScreenViewModel());

  // Presentation (MVVM) - wspoldzielony stan ekranu Strawa Dnia,
  // dzieki czemu wylosowany produkt przetrwa przelaczenie miedzy zakladkami
  locator.registerLazySingleton<StrawaDayScreenViewModel>(
    () => StrawaDayScreenViewModel(),
  );

  // Repositories
  locator.registerLazySingleton<ProductRepository>(() => ProductRepository());
  locator.registerLazySingleton<TagRepository>(() => TagRepository());
  locator.registerLazySingleton<ChainRepository>(() => ChainRepository());
  locator.registerLazySingleton<OsmRestaurantRepository>(() => OsmRestaurantRepository());

  // Services
  locator.registerLazySingleton<ProductService>(() => ProductService());
  locator.registerLazySingleton<TagService>(() => TagService());
  locator.registerLazySingleton<ChainService>(() => ChainService());
  locator.registerLazySingleton<LocationService>(() => LocationService());
  locator.registerLazySingleton<OsmRestaurantService>(() => OsmRestaurantService());
}