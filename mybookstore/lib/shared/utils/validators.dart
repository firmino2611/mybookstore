/// Função que valida o campo
/// [context] Contexto do widget
/// [value] Valor do campo
typedef ValidatorFunction = String? Function(String? value);

/// Função que valida se as senhas coincidem
/// [value] Valor do campo
/// [compareValue] Valor para comparação
typedef PasswordMatchValidator = String? Function(
  String? value,
  String compareValue,
);

/// Identifca cada tipo de validação
enum ValidatorType {
  isRequired,
  isValidEmail,
  isPasswordValid,
  isGreaterThanZero,
  isValidDate,
  isStrongPassword,
}

/// Mapa de funções de validação
Map<ValidatorType, ValidatorFunction> mapValidator = {
  ValidatorType.isRequired: ValidatorActions.isRequired,
  ValidatorType.isValidEmail: ValidatorActions.isValidEmail,
  ValidatorType.isPasswordValid: ValidatorActions.isPasswordValid,
  ValidatorType.isGreaterThanZero: ValidatorActions.isGreaterThanZero,
  ValidatorType.isValidDate: ValidatorActions.isValidDate,
  ValidatorType.isStrongPassword: ValidatorActions.isStrongPassword,
};

/// Classe que contém as validações de campos, para ser usada com o FieldValidator
/// [isRequired] Valida se o campo não é nulo
/// [isValidEmail] Valida se o campo é um email válido
/// [isPasswordValid] Valida se o campo é uma senha válida
abstract class ValidatorActions {
  /// Valida se o campo não é nulo
  static String? isRequired(String? value) {
    return value == null || value.isEmpty ? 'Campo obrigatório' : null;
  }

  /// Valida se o campo é um email válido
  static String? isValidEmail(String? value) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return value != null && !emailRegex.hasMatch(value)
        ? 'Email inválido'
        : null;
  }

  /// Valida se o campo é uma senha válida (validação simples)
  static String? isPasswordValid(String? value) {
    return value != null && value.length < 6 ? 'Senha inválida' : null;
  }

  /// Valida se a senha atende a critérios mais rigorosos:
  /// - Mais de 6 caracteres
  /// - Menos de 10 caracteres
  /// - Pelo menos 1 letra maiúscula
  /// - Pelo menos um caracter especial
  static String? isStrongPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo obrigatório';
    }

    if (value.length <= 6) {
      return 'A senha deve ter mais de 6 caracteres';
    }

    if (value.length >= 10) {
      return 'A senha deve ter menos de 10 caracteres';
    }

    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'A senha deve conter pelo menos 1 letra maiúscula';
    }

    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'A senha deve conter pelo menos 1 caractere especial';
    }

    return null;
  }

  static String? isPasswordMatch(String? value, String compareValue) {
    if (value == null || value.isEmpty) {
      return 'Campo obrigatório';
    }

    if (value != compareValue) {
      return 'As senhas não coincidem';
    }

    return null;
  }

  static String? isGreaterThanZero(String? value) {
    return value != null && double.tryParse(value) == null
        ? 'Campo obrigatório'
        : null;
  }

  static String? isValidDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Data inválida';
    }

    if (isValidDateFormat(value)) {
      return null;
    }
    return 'Data inválida';
  }

  static bool isValidDateFormat(String date) {
    try {
      DateTime.parse(date);
      return true;
    } catch (e) {
      return false;
    }
  }
}

/// Classe que valida os campos
/// [context] Contexto do widget
/// [validators] Lista de tipos de validação
class FieldValidator {
  const FieldValidator(this.validators);
  final List<ValidatorType> validators;

  String? call(String? value) {
    for (final validator in validators) {
      final error = mapValidator[validator]!(value);
      if (error != null) {
        return error;
      }
    }
    return null;
  }
}

/// Classe para validar se as senhas coincidem
class PasswordMatchingValidator {
  const PasswordMatchingValidator(this.passwordToCompare);
  final String passwordToCompare;

  String? call(String? value) {
    return ValidatorActions.isPasswordMatch(value, passwordToCompare);
  }
}
