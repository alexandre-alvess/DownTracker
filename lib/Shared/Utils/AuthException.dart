class AuthException implements Exception {

  static const Map<String, String> errors = {
    'EMAIL_EXISTS': 'E-mail já cadastrado.',
    'OPERATION_NOT_ALLOWED': 'Operação não permitida.',
    'TOO_MANY_ATTEMPTS_TRY_LATER': 'Excedido a quantidade de tentativas! Aguarde e tente novamente.',
    'EMAIL_NOT_FOUND': 'E-mail não encontrado!',
    'INVALID_PASSWORD': 'Senha inválida!',
    'USER_DISABLED': 'Usuário desativado!'
  };

  final String keyError;

  const AuthException(this.keyError);

  @override
  String toString() 
  {
    if (errors.containsKey(keyError))
    {
      return errors[keyError];
    }
    else
    {
      return 'Ocorreu um erro ao autenticar o usuário.';
    }
  }
}