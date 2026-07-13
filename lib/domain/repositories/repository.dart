abstract class Repository<T> {
  Future<List<T?>> getAll();
  Future<T?> getById(String id);
  Future<void> create(T obj);
  Future<void> update(T obj);
  Future<void> delete(String id);
}