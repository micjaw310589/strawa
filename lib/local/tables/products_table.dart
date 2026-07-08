import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'package:strawa/local/converters/decimal_converter.dart';

import 'chains_table.dart';

class Products extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get chainId => text().references(Chains, #id)();
  TextColumn get name => text()();
  TextColumn get imageUrl => text().nullable()();
  TextColumn get price => text().map(const DecimalConverter()).nullable()();
  IntColumn get calories => integer().nullable()();
  TextColumn get proteinG => text().map(const DecimalConverter()).nullable()();
  TextColumn get carbohydratesG => text().map(const DecimalConverter()).nullable()();
  TextColumn get fatG => text().map(const DecimalConverter()).nullable()();
  TextColumn get weightG => text().map(const DecimalConverter()).nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime).nullable()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime).nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
