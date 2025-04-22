class Either<Success, Failure> {
  Either._(this._value);

  /// Factory para criar um valor de sucesso
  factory Either.success(Success success) => Either._((success, null));

  /// Factory para criar um valor de falha
  factory Either.failure(Failure failure) => Either._((null, failure));

  final (Success?, Failure?) _value;

  /// Verifica se é um valor de sucesso
  bool get isSuccess => _value.$1 != null;

  /// Verifica se é um valor de falha
  bool get isFailure => _value.$2 != null;

  /// Obtém o valor de sucesso, ou lança uma exceção se não for Success
  Success get success {
    if (!isSuccess) {
      throw StateError('No Success value present');
    }
    return _value.$1!;
  }

  /// Obtém o valor de falha, ou lança uma exceção se não for Failure
  Failure get failure {
    if (!isFailure) {
      throw StateError('No Failure value present');
    }
    return _value.$2!;
  }

  /// Aplica uma função ao valor, dependendo se é Success ou Failure
  T fold<T>(
    T Function(Success success) onSuccess,
    T Function(Failure failure) onFailure,
  ) {
    return isSuccess ? onSuccess(success) : onFailure(failure);
  }
}
