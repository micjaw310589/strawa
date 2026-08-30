import 'package:flutter/material.dart';
import 'package:strawa/locator.dart';
import 'package:strawa/presentation/widgets/nav_bar_viewmodel.dart';

class MapScreenViewModel extends ChangeNotifier {
  final NavBarViewModel _navBarViewModel = locator<NavBarViewModel>();

  final String title;

  MapScreenViewModel({
    this.title = 'Mapa',
  }) {
    _navBarViewModel.setActiveItem(NavBarItem.mapa);
  }
}