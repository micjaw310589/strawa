import 'package:flutter/material.dart';
import 'package:strawa/locator.dart';
import 'package:strawa/presentation/home_screen/home_screen_view.dart';
import 'package:strawa/presentation/nearby/nearby_screen_viewmodel.dart';
import 'package:strawa/presentation/widgets/nav_bar.dart';
import 'package:strawa/presentation/widgets/restaurant_tile_view.dart';

class NearbyScreenView extends StatefulWidget {
  const NearbyScreenView({super.key});

  @override
  State<NearbyScreenView> createState() => _NearbyScreenViewState();
}

class _NearbyScreenViewState extends State<NearbyScreenView> {
  late final NearbyScreenViewModel _viewModel;
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _viewModel = locator<NearbyScreenViewModel>();
    _viewModel.activate();

    // Przywrócenie wpisanego wcześniej tekstu wyszukiwania
    _searchController = TextEditingController(text: _viewModel.searchQuery);
    _searchController.selection = TextSelection.fromPosition(
      TextPosition(offset: _searchController.text.length),
    );

    // Automatyczne pobieranie tylko przy pierwszym wejściu (gdy brak zapisanych danych)
    if (!_viewModel.hasSearched && !_viewModel.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _viewModel.loadNearbyRestaurants();
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreenView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Restauracje w okolicy',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            elevation: 1,
            actions: [
              IconButton(
                icon: const Icon(Icons.my_location),
                tooltip: 'Pobierz moją lokalizację',
                onPressed: _viewModel.isLoading ? null : _viewModel.loadNearbyRestaurants,
              ),
            ],
          ),
          body: Column(
            children: [
              _buildTopControls(),
              Expanded(child: _buildContent()),
              if (_viewModel.hasSearched && _viewModel.restaurants.isNotEmpty)
                _buildBottomOffersButton(),
            ],
          ),
          bottomNavigationBar: const NavBar(),
        );
      },
    );
  }

  Widget _buildTopControls() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            onChanged: _viewModel.filterBySearchText,
            decoration: InputDecoration(
              hintText: 'Szukaj po nazwie lub ulicy...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _viewModel.filterBySearchText('');
                      },
                    )
                  : null,
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Promień wyszukiwania:',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              ),
              DropdownButton<double>(
                value: _viewModel.radiusInMeters,
                isDense: true,
                underline: const SizedBox(),
                items: const [
                  DropdownMenuItem(value: 1000.0, child: Text('1 km')),
                  DropdownMenuItem(value: 2000.0, child: Text('2 km')),
                  DropdownMenuItem(value: 5000.0, child: Text('5 km')),
                  DropdownMenuItem(value: 10000.0, child: Text('10 km')),
                  DropdownMenuItem(value: 15000.0, child: Text('15 km')),
                ],
                onChanged: (value) {
                  if (value != null) _viewModel.setRadius(value);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    // Pełnoekranowy loader tylko przy pierwszym pobieraniu
    if (_viewModel.isLoading && !_viewModel.hasSearched) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 12),
            Text('Szukam restauracji w pobliżu...'),
          ],
        ),
      );
    }

    if (_viewModel.errorMessage != null && _viewModel.restaurants.isEmpty) {
      return RefreshIndicator(
        onRefresh: _viewModel.loadNearbyRestaurants,
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.location_off, size: 56, color: Colors.orange),
                      const SizedBox(height: 12),
                      Text(
                        _viewModel.errorMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _viewModel.loadNearbyRestaurants,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Spróbuj ponownie'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    if (_viewModel.restaurants.isEmpty) {
      return RefreshIndicator(
        onRefresh: _viewModel.loadNearbyRestaurants,
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.store_mall_directory_outlined, size: 56, color: Colors.grey),
                    SizedBox(height: 12),
                    Text('Nie znaleziono żadnych lokali w tym promieniu.'),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    // Lista wyników z obsługą gestu Pull-to-Refresh
    return RefreshIndicator(
      onRefresh: _viewModel.loadNearbyRestaurants,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(top: 6, bottom: 12),
        itemCount: _viewModel.restaurants.length,
        itemBuilder: (context, index) {
          final restaurant = _viewModel.restaurants[index];
          return RestaurantTileView(
            restaurant: restaurant,
            onSearchOffers: () {
              _viewModel.selectRestaurantOffers(restaurant.name);
              _navigateToHome();
            },
          );
        },
      ),
    );
  }

  Widget _buildBottomOffersButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 20),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2E7D32),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: () {
          _viewModel.selectAllNearbyOffers();
          _navigateToHome();
        },
        child: Text(
          'Wyszukaj oferty (${_viewModel.restaurants.length} restauracji w pobliżu)',
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}