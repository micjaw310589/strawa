import 'package:flutter/material.dart';
import 'package:strawa/domain/entities/enums/sort_product_enum.dart';
import 'package:strawa/presentation/home_screen/sorting_screen_viewmodel.dart';

class SortingScreen extends StatefulWidget {
  const SortingScreen({
    super.key,
  });

  @override
  State<SortingScreen> createState() => _SortingScreenState();
}

class _SortingScreenState extends State<SortingScreen> {
  late final SortingScreenViewModel _viewModel;

  @override
  void initState() {
    super.initState();

    _viewModel = SortingScreenViewModel(
      onSortingApplied: () {
        Navigator.pop(context);
      }
    );
  }


@override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, child) {
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
          child: Material(
            color: Colors.transparent,
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildOrderRadio(),
                        const SizedBox(height: 20),
                        _buildOptionsRadio(),
                        const SizedBox(height: 60),
                      ],
                    ),
                  ),
                ),
                _buildApplyButton(),
              ],
            ),
          ),
        );
      },
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
            'Sortowanie',
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

  Widget _buildOptionsRadio() {
    return RadioGroup<SortProduct>(
      groupValue: _viewModel.selectedOption,
      onChanged: (SortProduct? value) {
        if (value != null) {
          _viewModel.updateSortingOption(value);
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sortuj wg',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...SortingScreenViewModel.options.entries.map((entry) {
            return RadioListTile<SortProduct>(
              title: Text(entry.value),
              value: entry.key,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildOrderRadio() {
    return RadioGroup<bool>(
      groupValue: _viewModel.selectedOrder,
      onChanged: (bool? value) {
        if (value != null) {
          _viewModel.updateSortingOrder(value);
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Kolejność',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...SortingScreenViewModel.order.entries.map((entry) {
            return RadioListTile<bool>(
              title: Text(entry.value),
              value: entry.key,
            );
          }),
        ],
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
              onPressed: _viewModel.resetToDefault,
              child: const Text(
                'Przywróć domyślne',
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
              onPressed: _viewModel.applySorting,
              child: const Text(
                'Zastosuj',
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
}