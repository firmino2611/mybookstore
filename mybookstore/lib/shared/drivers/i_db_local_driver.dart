abstract interface class IDbLocalDriver {
  Future<void> add({
    required String collection,
    required Map<String, dynamic> value,
    String? doc,
  });

  Future<void> update({
    required String collection,
    required Map<String, dynamic> value,
    required String doc,
  });

  Future<void> remove({required String collection, String? doc});

  Future<Map<String, dynamic>?> select({
    required String collection,
    String? doc,
  });
}
