import 'package:flutter/material.dart';

enum NavBarItem { mapa, home, strawaDnia }

/// ViewModel paska nawigacji.
///
/// Przechowuje informację o aktualnie aktywnym widoku, dzięki czemu
/// NavBar może zablokować przejście na widok, na którym już się znajdujemy.
/// Rejestrowany jako singleton w locatorze, więc wszystkie instancje
/// NavBar współdzielą ten sam stan.
class NavBarViewModel extends ChangeNotifier {
  NavBarItem _currentItem = NavBarItem.home;

  NavBarItem get currentItem => _currentItem;

  bool isCurrent(NavBarItem item) => _currentItem == item;

  void setActiveItem(NavBarItem item) {
    if (_currentItem == item) return;

    _currentItem = item;
    notifyListeners();
  }
}