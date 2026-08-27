import 'package:flutter/material.dart';
import 'package:strawa/presentation/home_screen_view.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
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
        child: Row(
          children: [
            _buildItem(
              icon: Icons.map,
              label: 'Mapa',
              enabled: false, // wyłączony: widok Mapa jeszcze nie istnieje
              // TODO: odkomentować po utworzeniu MapScreen
              // onTap: () => _switchTo(context, const MapScreen()),
            ),
            _buildItem(
              icon: Icons.home,
              label: 'Home',
              enabled: true,
              onTap: () => _switchTo(context, const HomeScreenView()),
            ),
            _buildItem(
              icon: Icons.restaurant,
              label: 'Strawa Dnia',
              enabled: false, // wyłączony: widok Strawa Dnia jeszcze nie istnieje
              // TODO: odkomentować po utworzeniu StrawaDayScreen
              // onTap: () => _switchTo(context, const StrawaDayScreen()),
            ),
          ],
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

  Widget _buildItem({
    required IconData icon,
    required String label,
    required bool enabled,
    VoidCallback? onTap,
  }) {
    final Color color = enabled ? Colors.blue : Colors.grey;
    return Expanded(
      child: InkWell(
        onTap: enabled ? onTap : null,
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
                  fontWeight: FontWeight.w500,
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
