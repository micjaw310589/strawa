import 'package:flutter/material.dart';
import 'package:decimal/decimal.dart';
import 'package:strawa/services/product_service.dart';
import 'package:strawa/domain/dtos/product_list_element_dto.dart';

class FilterPanel extends StatefulWidget {
  final List<String> initialTags;
  final List<String> initialChains;
  final double initialMinPrice;
  final double initialMaxPrice;
  final double initialMinRating;
  final Function(List<ProductListElementDto>, List<String>, List<String>, double, double, double) onFiltersApplied;

  const FilterPanel({
    super.key,
    required this.onFiltersApplied,
    this.initialTags = const [],
    this.initialChains = const [],
    this.initialMinPrice = 0.0,
    this.initialMaxPrice = 100.0,
    this.initialMinRating = 0.0,
  });

  @override
  State<FilterPanel> createState() => _FilterPanelState();
}

class _FilterPanelState extends State<FilterPanel> {
  final ProductService _productService = ProductService();

  // Filter state
  late List<String> _selectedTags;
  late List<String> _selectedChains;
  late RangeValues _priceRange;
  late double _minRating;

  @override
  void initState() {
    super.initState();
    _selectedTags = List.from(widget.initialTags);
    _selectedChains = List.from(widget.initialChains);

    // Ensure price range values are within the slider's min/max bounds
    final minPrice = widget.initialMinPrice.clamp(0.0, 100.0);
    final maxPrice = widget.initialMaxPrice.clamp(0.0, 100.0);
    _priceRange = RangeValues(minPrice, maxPrice);

    _minRating = widget.initialMinRating;
  }

  // Available options
  List<String> _availableTags = [
    'Vegan', 'Vegetarian', 'Gluten-free', 'Spicy', 'New', 'Popular', 'Healthy'
  ];

  List<String> _availableChains = [
    'McDonalds', 'KFC', 'Burger King', 'Subway', 'Starbucks', 'Pizza Hut'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTagsSection(),
                  const SizedBox(height: 20),
                  _buildChainsSection(),
                  const SizedBox(height: 20),
                  _buildPriceSlider(),
                  const SizedBox(height: 20),
                  _buildRatingFilter(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
          _buildApplyButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Filters',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildTagsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tags',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _availableTags.map((tag) {
            final isSelected = _selectedTags.contains(tag);
            return FilterChip(
              label: Text(tag),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedTags.add(tag);
                  } else {
                    _selectedTags.remove(tag);
                  }
                });
              },
              backgroundColor: Colors.grey[200],
              selectedColor: Colors.blue[200],
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildChainsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Restaurant Chains',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _availableChains.map((chain) {
            final isSelected = _selectedChains.contains(chain);
            return FilterChip(
              label: Text(chain),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedChains.add(chain);
                  } else {
                    _selectedChains.remove(chain);
                  }
                });
              },
              backgroundColor: Colors.grey[200],
              selectedColor: Colors.green[200],
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPriceSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Price Range',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        RangeSlider(
          values: _priceRange,
          min: 0,
          max: 100,
          divisions: 20,
          labels: RangeLabels(
            '\$${_priceRange.start.round()}',
            '\$${_priceRange.end.round()}',
          ),
          onChanged: (values) {
            setState(() {
              _priceRange = values;
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('\$${_priceRange.start.round()}'),
            Text('\$${_priceRange.end.round()}'),
          ],
        ),
      ],
    );
  }

  Widget _buildRatingFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Minimum Rating',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            _buildRatingButton(3.0, '>= 3.0'),
            _buildRatingButton(3.5, '>= 3.5'),
            _buildRatingButton(4.0, '>= 4.0'),
            _buildRatingButton(4.5, '>= 4.5'),
            _buildRatingButton(4.75, '>= 4.75'),
          ],
        ),
      ],
    );
  }

  Widget _buildRatingButton(double rating, String label) {
    final isSelected = _minRating == rating;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _minRating = selected ? rating : 0.0;
        });
      },
      backgroundColor: Colors.grey[200],
      selectedColor: Colors.orange[200],
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black,
      ),
    );
  }

  Widget _buildApplyButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: Colors.grey),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: _clearFilters,
              child: const Text(
                'Clear Filters',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: _applyFilters,
              child: const Text(
                'Apply Filters',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _clearFilters() {
    setState(() {
      _selectedTags.clear();
      _selectedChains.clear();
      _priceRange = const RangeValues(0, 100);
      _minRating = 0.0;
    });
  }

  Future<void> _applyFilters() async {
    try {
      final filteredProducts = await _productService.getProductsForMainList(
        page: 1,
        pageSize: 20,
        tagNames: _selectedTags,
        chainNames: _selectedChains,
        minPrice: Decimal.fromInt(_priceRange.start.round()),
        maxPrice: Decimal.fromInt(_priceRange.end.round()),
        minRating: _minRating,
      );

      if (mounted) {
        widget.onFiltersApplied(
          filteredProducts,
          _selectedTags,
          _selectedChains,
          _priceRange.start,
          _priceRange.end,
          _minRating
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error applying filters: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}