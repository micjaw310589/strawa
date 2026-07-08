import 'package:drift/drift.dart';
import 'package:path_provider/path_provider.dart';

part '../database/database.g.dart';

@DriftDatabase(tables: [Chains, Tags, Products, Reviews, News, ProductsTags])
class Database extends _$Database {
  Database() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  //TODO
}