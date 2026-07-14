abstract class Repository<T> {
  Future<List<T>> fetchAll();
  Future<T> fetchById(String id);
  Future<void> insert(T obj);
  Future<void> update(T obj);
  Future<void> delete(String id);
}