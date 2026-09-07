import 'package:flutter/material.dart';
import 'package:strawa/locator.dart';
import 'package:strawa/presentation/home_screen/home_screen_view.dart';
import 'package:strawa/presentation/nearby_screen/nearby_screen_view.dart';
import 'package:strawa/presentation/todays_strawa_screen/strawa_day_screen_view.dart';
import 'package:strawa/presentation/widgets/nav_bar_viewmodel.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final NavBarViewModel viewModel = locator<NavBarViewModel>();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 51), // 0.2 * 255 = 51
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: ListenableBuilder(
          listenable: viewModel,
          builder: (context, child) {
            return Row(
              children: [
                _buildItem(
                  context: context,
                  viewModel: viewModel,
                  item: NavBarItem.wOkolicy,
                  icon: Icons.location_pin,
                  label: 'Restauracje',
                ),
                _buildItem(
                  context: context,
                  viewModel: viewModel,
                  item: NavBarItem.home,
                  icon: Icons.home,
                  label: 'Główna',
                ),
                _buildItem(
                  context: context,
                  viewModel: viewModel,
                  item: NavBarItem.strawaDnia,
                  icon: Icons.local_restaurant,
                  label: 'Strawa Dnia',
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _switchTo(BuildContext context, Widget screen) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  Widget _screenFor(NavBarItem item) {
    switch (item) {
      case NavBarItem.wOkolicy:
        return const NearbyScreenView();
      case NavBarItem.home:
        return const HomeScreenView();
      case NavBarItem.strawaDnia:
        return const StrawaDayScreenView();
    }
  }

  Widget _buildItem({
    required BuildContext context,
    required NavBarViewModel viewModel,
    required NavBarItem item,
    required IconData icon,
    required String label,
  }) {
    final bool isCurrent = viewModel.isCurrent(item);
    final Color color = isCurrent ? Colors.blue : Colors.grey;

    return Expanded(
      child: InkWell(
        onTap: isCurrent ? null : () => _switchTo(context, _screenFor(item)),
        child: SizedBox(
          height: 56.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
