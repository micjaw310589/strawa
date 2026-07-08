import 'package:drift/drift.dart';

import 'package:strawa/domain/entities/product.dart';
import 'package:strawa/local/database.dart';
import 'package:strawa/local/tables/products_table.dart';

part '../../database/daos/chain_dao.g.dart';

@DriftAccessor(tables: [Products])
class ProductDao extends DatabaseAccessor<Database> with _$ChainDaoMixin {
  ProductDao(Database db) : super(db);

  //TODO
}