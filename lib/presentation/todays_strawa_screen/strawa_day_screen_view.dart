import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:strawa/locator.dart';
import 'package:strawa/presentation/todays_strawa_screen/strawa_day_screen_viewmodel.dart';
import 'package:strawa/presentation/widgets/nav_bar.dart';
import 'package:strawa/presentation/widgets/product_extended_tile.dart';
import 'package:strawa/presentation/widgets/product_extended_tile_viewmodel.dart';

class StrawaDayScreenView extends StatefulWidget {
  const StrawaDayScreenView({super.key});

  @override
  State<StrawaDayScreenView> createState() => _StrawaDayScreenViewState();
}

class _StrawaDayScreenViewState extends State<StrawaDayScreenView>
    with SingleTickerProviderStateMixin {
  // odchylenie przyspieszenia od grawitacji (m/s^2) uznawane za potrzasniecie
  static const double _shakeThreshold = 12.0;
  static const Duration _shakeCooldown = Duration(milliseconds: 1200);

  final StrawaDayScreenViewModel _viewModel =
      locator<StrawaDayScreenViewModel>();

  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  DateTime _lastShakeTime = DateTime.fromMillisecondsSinceEpoch(0);
  late final AnimationController _shakeController;

  @override
  void initState() {
    super.initState();

    _viewModel.clearDrawIfFromPreviousDay();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _startListeningForShake();
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    _shakeController.dispose();
    super.dispose();
  }

  void _startListeningForShake() {
    try {
      _accelerometerSubscription = accelerometerEventStream().listen(
        _onAccelerometerEvent,
        onError: (Object error) {
          // urzadzenie bez akcelerometru - gest potrzasniecia jest niedostepny,
          // pozostaje losowanie przyciskiem
        },
      );
    } catch (_) {
      // platforma bez obslugi czujnikow
    }
  }

  void _onAccelerometerEvent(AccelerometerEvent event) {
    final double magnitude = math.sqrt(
      event.x * event.x + event.y * event.y + event.z * event.z,
    );
    if ((magnitude - 9.81).abs() < _shakeThreshold) {
      return;
    }

    final DateTime now = DateTime.now();
    if (now.difference(_lastShakeTime) < _shakeCooldown) {
      return;
    }
    _lastShakeTime = now;

    _playShakeAnimation();
    _viewModel.drawRandomProduct();
  }

  void _playShakeAnimation() {
    if (!_shakeController.isAnimating) {
      unawaited(HapticFeedback.mediumImpact());
      _shakeController.forward(from: 0.0);
    }
  }

  void _drawProduct() {
    _playShakeAnimation();
    _viewModel.drawRandomProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _viewModel.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        elevation: 4,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _viewModel,
          builder: (context, child) => _buildBody(),
        ),
      ),
      bottomNavigationBar: const NavBar(),
    );
  }

  Widget _buildBody() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: AnimatedBuilder(
          animation: _shakeController,
          builder: (context, child) {
            final double offset = _shakeController.isAnimating
                ? math.sin(_shakeController.value * math.pi * 3) *
                      12.0 *
                      (1.0 - _shakeController.value)
                : 0.0;
            return Transform.translate(offset: Offset(offset, 0), child: child);
          },
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: Tween<double>(
                    begin: 0.96,
                    end: 1.0,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: _buildStateContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildStateContent() {
    if (_viewModel.isDrawing) {
      return KeyedSubtree(
        key: const ValueKey('loading'),
        child: _buildLoadingTile(),
      );
    }

    if (_viewModel.hasDrawnProduct) {
      return KeyedSubtree(
        key: const ValueKey('drawn'),
        child: Column(
          children: [
            ProductExtendedTile(
              viewModel: ProductExtendedTileViewModel(
                product: _viewModel.product!,
              ),
            ),
            const SizedBox(height: 24.0),
            _buildShakeHint('Potrząśnij telefonem, aby wylosować ponownie'),
            const SizedBox(height: 24.0),
            _buildDrawButton(
              label: 'Wylosuj ponownie',
              onPressed: _drawProduct,
            ),
          ],
        ),
      );
    }

    return KeyedSubtree(
      key: const ValueKey('idle'),
      child: _buildIdleContent(),
    );
  }

  Widget _buildIdleContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 48.0,
          backgroundColor: Colors.orange[50],
          child: const Icon(
            Icons.restaurant_menu,
            size: 48.0,
            color: Colors.deepOrange,
          ),
        ),
        const SizedBox(height: 24.0),
        const Text(
          'Nie wiesz, co dziś zjeść?',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12.0),
        Text(
          'Wylosuj swoją strawę dnia i odkryj coś nowego!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
        const SizedBox(height: 8.0),
        _buildShakeHint('Potrząśnij telefonem, aby wylosować'),
        const SizedBox(height: 24.0),
        _buildDrawButton(label: 'Wylosuj produkt', onPressed: _drawProduct),
        if (_viewModel.errorMessage != null) ...[
          const SizedBox(height: 16.0),
          Text(
            _viewModel.errorMessage!,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: Colors.redAccent),
          ),
        ],
      ],
    );
  }

  Widget _buildShakeHint(String message) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.vibration, size: 16.0, color: Colors.grey[500]),
        const SizedBox(width: 6.0),
        Text(
          message,
          style: TextStyle(fontSize: 13, color: Colors.grey[500]),
        ),
      ],
    );
  }

  Widget _buildLoadingTile() {
    final double tileWidth = MediaQuery.sizeOf(context).width * 0.92;

    return Container(
      width: tileWidth,
      height: 360.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 77), // 0.3 * 255 = 77
            spreadRadius: 2,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.deepOrange),
          SizedBox(height: 16.0),
          Text(
            'Losowanie produktu...',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: _viewModel.isDrawing ? null : onPressed,
      icon: const Icon(Icons.casino),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
      ),
    );
  }
}
