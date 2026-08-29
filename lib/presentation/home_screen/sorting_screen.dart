// import 'package:flutter/material.dart';
// import 'package:strawa/presentation/home_screen/filters_screen_viewmodel.dart';
// import 'package:strawa/presentation/home_screen/sorting_screen_viewmodel.dart';

// class SortingScreen extends StatefulWidget {
//   const SortingScreen({
//     super.key,
//   });

//   @override
//   State<SortingScreen> createState() => _SortingScreenState();
// }

// class _SortingScreenState extends State<SortingScreen> {
//   late final SortingScreenViewModel _viewModel;

//   @override
//   void initState() {
//     super.initState();

//     _viewModel = SortingScreenViewModel(

//       onFiltersApplied: () {
//         print(_viewModel.selectedFilters);
//         Navigator.pop(context);
//       }
//     );

//     // Ensure price range values are within the slider's min/max bounds
//     final minPrice = _viewModel.selectedFilters.minPrice.clamp(0.0, 100.0);
//     final maxPrice = _viewModel.selectedFilters.maxPrice.clamp(0.0, 100.0);
//     if (!_viewModel.isPriceRangeSame(minPrice, maxPrice)) {
//       _viewModel.updatePriceRange(minPrice, maxPrice);
//     }

//     _viewModel.loadTagsAndChains();
//   }


//   @override
//   Widget build(BuildContext context) {
//     return ListenableBuilder(
//       listenable: _viewModel,
//       builder: (context, child) {
//         return Container(
//           height: MediaQuery.of(context).size.height * 0.75,
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black26,
//                 blurRadius: 10,
//                 spreadRadius: 1,
//               ),
//             ],
//           ),
//           child: Column(
//             children: [
//               _buildHeader(),
//               Expanded(
//                 child: SingleChildScrollView(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _buildTagsSection(),
//                       const SizedBox(height: 20),
//                       _buildChainsSection(),
//                       const SizedBox(height: 20),
//                       _buildPriceSlider(),
//                       const SizedBox(height: 20),
//                       _buildRatingFilter(),
//                       const SizedBox(height: 30),
//                     ],
//                   ),
//                 ),
//               ),
//               _buildApplyButton(),
//             ],
//           ),
//         );
//       }
//     );
//   }

//   Widget _buildHeader() {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//       decoration: const BoxDecoration(
//         border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           const Text(
//             'Filters',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           IconButton(
//             icon: const Icon(Icons.close),
//             onPressed: () => Navigator.pop(context),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTagsSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Tags',
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 8),
//         if (_viewModel.isLoadingTags)
//           const Center(child: CircularProgressIndicator())
//         else if (_viewModel.tags.isEmpty)
//           const Text('No tags available')
//         else
//           Wrap(
//             spacing: 8,
//             runSpacing: 8,
//             children: _viewModel.tags.map((tag) {
//               final isSelected = _viewModel.selectedFilters.tags.contains(tag);
//               return FilterChip(
//                 label: Text(tag),
//                 selected: isSelected,
//                 onSelected: (selected) {
//                   setState(() {
//                     if (selected) {
//                       _viewModel.addTag(tag);
//                     } else {
//                       _viewModel.removeTag(tag);
//                     }
//                   });
//                 },
//                 backgroundColor: Colors.grey[200],
//                 selectedColor: Colors.blue[200],
//                 labelStyle: TextStyle(
//                   color: isSelected ? Colors.white : Colors.black,
//                 ),
//               );
//             }).toList(),
//           ),
//       ],
//     );
//   }

//   Widget _buildChainsSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Restaurant Chains',
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 8),
//         if (_viewModel.isLoadingChains)
//           const Center(child: CircularProgressIndicator())
//         else if (_viewModel.chains.isEmpty)
//           const Text('No tags available')
//         else
//           Wrap(
//             spacing: 8,
//             runSpacing: 8,
//             children: _viewModel.chains.map((chain) {
//               final isSelected = _viewModel.selectedFilters.chains.contains(chain);
//               return FilterChip(
//                 label: Text(chain),
//                 selected: isSelected,
//                 onSelected: (selected) {
//                   setState(() {
//                     if (selected) {
//                       _viewModel.addChain(chain);
//                     } else {
//                       _viewModel.removeChain(chain);
//                     }
//                   });
//                 },
//                 backgroundColor: Colors.grey[200],
//                 selectedColor: Colors.green[200],
//                 labelStyle: TextStyle(
//                   color: isSelected ? Colors.white : Colors.black,
//                 ),
//               );
//             }).toList(),
//           ),
//       ],
//     );
//   }

//   Widget _buildPriceSlider() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Price Range',
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 8),
//         RangeSlider(
//           values: RangeValues(_viewModel.selectedFilters.minPrice, _viewModel.selectedFilters.maxPrice),
//           min: 0,
//           max: 100,
//           divisions: 20,
//           labels: RangeLabels(
//             '\$${_viewModel.selectedFilters.minPrice.round()}',
//             '\$${_viewModel.selectedFilters.maxPrice.round()}',
//           ),
//           onChanged: (values) {
//             _viewModel.updatePriceRange(values.start, values.end);
//           },
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text('\$${_viewModel.selectedFilters.minPrice.round()}'),
//             Text('\$${_viewModel.selectedFilters.maxPrice.round()}'),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildRatingFilter() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Minimum Rating',
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Wrap(
//           spacing: 8,
//           children: _viewModel.ratings
//             .map((rating) => _buildRatingButton(rating, ">= $rating"))
//             .toList(),

//         ),
//       ],
//     );
//   }

//   Widget _buildRatingButton(double rating, String label) {
//     final isSelected = _viewModel.selectedFilters.minRating == rating;
//     return ChoiceChip(
//       label: Text(label),
//       selected: isSelected,
//       onSelected: (selected) {
//         _viewModel.updateMinRating(rating);
//       },
//       backgroundColor: Colors.grey[200],
//       selectedColor: Colors.orange[200],
//       labelStyle: TextStyle(
//         color: isSelected ? Colors.white : Colors.black,
//       ),
//     );
//   }

//   Widget _buildApplyButton() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: const BoxDecoration(
//         border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: OutlinedButton(
//               style: OutlinedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//                 side: const BorderSide(color: Colors.grey),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               onPressed: _viewModel.clearFilters,
//               child: const Text(
//                 'Clear Filters',
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.black87,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//                 backgroundColor: Colors.blue,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               onPressed: _viewModel.applyFilters,
//               child: const Text(
//                 'Apply Filters',
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }