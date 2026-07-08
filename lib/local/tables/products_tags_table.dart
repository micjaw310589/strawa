import 'package:drift/drift.dart';

import 'products_table.dart';
import 'tags_table.dart';

// Cross-reference table
class ProductsTags extends Table {
  TextColumn get productId => text().references(Products, #id)();
  TextColumn get tagId => text().references(Tags, #id)();

  @override
  Set<Column> get primaryKey => {productId, tagId};
}