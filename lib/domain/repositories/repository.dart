abstract class Repository<T> {
  Future<List<T?>> getAll();
  Future<T?> getById(String id);
  Future<void> create(T chain);
  Future<void> update(T chain);
  Future<void> delete(String id);
}