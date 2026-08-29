import 'package:flutter/material.dart';
import 'package:strawa/presentation/map_screen/map_screen_viewmodel.dart';
import 'package:strawa/presentation/widgets/nav_bar.dart';

class MapScreenView extends StatefulWidget {
  const MapScreenView({super.key});

  @override
  State<MapScreenView> createState() => _MapScreenViewState();
}

class _MapScreenViewState extends State<MapScreenView> {
  late final MapScreenViewModel _viewModel;

  @override
  void initState() {
    super.initState();

    _viewModel = MapScreenViewModel();
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