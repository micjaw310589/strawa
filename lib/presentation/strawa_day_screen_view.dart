import 'package:flutter/material.dart';
import 'package:strawa/presentation/strawa_day_screen_viewmodel.dart';
import 'package:strawa/presentation/widgets/nav_bar.dart';

class StrawaDayScreenView extends StatefulWidget {
  const StrawaDayScreenView({super.key});

  @override
  State<StrawaDayScreenView> createState() => _StrawaDayScreenViewState();
}

class _StrawaDayScreenViewState extends State<StrawaDayScreenView> {
  late final StrawaDayScreenViewModel _viewModel;

  @override
  void initState() {
    super.initState();

    _viewModel = StrawaDayScreenViewModel();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, child) {
        return Scaffold(
          body: SafeArea(
            child: Center(
              child: Text(
                _viewModel.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          bottomNavigationBar: const NavBar(),
        );
      },
    );
  }
}