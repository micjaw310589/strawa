import 'package:flutter/material.dart';

@immutable
class Filters {
  final List<String> initialTags;
  final List<String> initialChains;
  final double initialMinPrice;
  final double initialMaxPrice;
  final double initialMinRating;

  const Filters({
    this.initialTags = const [],
    this.initialChains = const [],
    this.initialMinPrice = 0.0,
    this.initialMaxPrice = 100.0,
    this.initialMinRating = 0.0,
  });
}