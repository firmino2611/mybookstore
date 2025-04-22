import 'package:localstore/localstore.dart';
import 'package:mybookstore/shared/drivers/i_db_local_driver.dart';

class LocalStoreDriver implements IDbLocalDriver {
  final Localstore plugin = Localstore.instance;

  @override
  Future<void> add({
    required String collection,
    required Map<String, dynamic> value,
    String? doc,
  }) async {
    await plugin.collection(collection).doc(doc).set(value);
  }

  @override
  Future<void> remove({required String collection, String? doc}) async {
    await plugin.collection(collection).doc(doc).delete();
  }

  @override
  Future<Map<String, dynamic>?> select({
    required String collection,
    String? doc,
  }) {
    if (doc == null) {
      return plugin.collection(collection).get();
    }
    return plugin.collection(collection).doc(doc).get();
  }

  @override
  Future<void> update({
    required String collection,
    required Map<String, dynamic> value,
    required String doc,
  }) async {
    await plugin.collection(collection).doc(doc).set(value);
  }
}
