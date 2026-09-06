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

  Filters copyWith({
    List<String>? tags,
    List<String>? chains,
    double? minPrice,
    double? maxPrice,
    double? minRating
  }) {
    return Filters(
      tags: tags ?? this.tags,
      chains: chains ?? this.chains,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      minRating: minRating ?? this.minRating
    );
  }

  @override
  String toString() {
    return "Tag count: ${tags.length}\nChain count: ${chains.length}\nmin: $minPrice\nmax: $maxPrice\nrating: $minRating\n";
  }
}