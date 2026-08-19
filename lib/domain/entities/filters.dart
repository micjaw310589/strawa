import 'package:flutter/material.dart';

@immutable
class Filters {
  final List<String> tags;
  final List<String> chains;
  final double minPrice;
  final double maxPrice;
  final double minRating;

  const Filters({
    this.tags = const [],
    this.chains = const [],
    this.minPrice = 0.0,
    this.maxPrice = 100.0,
    this.minRating = 0.0,
  });
}