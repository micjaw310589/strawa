import 'package:flutter/material.dart';
import 'package:strawa/domain/entities/filters.dart';
import 'package:strawa/services/chain_service.dart';
import 'package:strawa/services/product_service.dart';
import 'package:strawa/services/tag_service.dart';

class FilterPanelViewModel extends ChangeNotifier {
  final ProductService _productService = ProductService();
  final TagService _tagService = TagService();
  final ChainService _chainService = ChainService();
}