import 'package:flutter/material.dart';
import 'package:strawa/locator.dart';
import 'package:strawa/presentation/widgets/nav_bar_viewmodel.dart';

class StrawaDayScreenViewModel extends ChangeNotifier {
  final NavBarViewModel _navBarViewModel = locator<NavBarViewModel>();

  final String title;

  StrawaDayScreenViewModel({
    this.title = 'Strawa Dnia',
  }) {
    _navBarViewModel.setActiveItem(NavBarItem.strawaDnia);
  }
}