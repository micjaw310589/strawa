import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

class News extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get title => text()();
  TextColumn get content => text()();
  TextColumn get imageUrl => text().nullable()();
  DateTimeColumn get publishedAt => dateTime().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
