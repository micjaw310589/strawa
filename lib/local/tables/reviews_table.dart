import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'products_table.dart';

class Reviews extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get productId => text().references(Products, #id)();
  IntColumn get rating => integer().customConstraint("NOT NULL CHECK (1 <= rating AND rating <= 5)")();
  TextColumn get androidId => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime).nullable()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}