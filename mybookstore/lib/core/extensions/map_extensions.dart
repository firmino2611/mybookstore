extension MapExtensions<K, V> on Map<K, V> {
  Map<K, V> removeNulls() {
    return Map.fromEntries(entries.where((entry) => entry.value != null));
  }

  bool isNull(String key) {
    return this[key] == null;
  }

  dynamic isNotNull(String key) {
    return this[key] != null;
  }

  /// Retorna o valor de uma chave do objeto mapa.
  Type getFromObject<Type>(String key) {
    final keys = key.split('.'); // Divide a chave pelos pontos
    dynamic value = this;

    for (final k in keys) {
      if (value is Map<String, dynamic> && value.containsKey(k)) {
        value = value[k]; // Acessa o próximo nível
      } else {
        throw ArgumentError(
          'The field `$key` does not exist or is not accessible.',
        );
      }
    }
    return value;
  }

  /// Retorna o valor de uma chave do objeto mapa.
  /// Se a chave não existir, retorna null.
  /// Se a chave existir, mas não for do tipo Type, retorna null.
  /// Caso contrário, retorna o valor.
  Type get<Type>(String key) {
    final value = this[key];
    if (value is! Type) {
      throw ArgumentError('The field `$key` is not of Type `$Type`.');
    }
    return value;
  }
}
