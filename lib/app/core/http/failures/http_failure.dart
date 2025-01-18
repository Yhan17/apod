enum HttpFailure {
  badRequest, // 400
  unauthorized, // 401
  forbidden, // 403
  notFound, // 404
  internalServerError, // 500
  serviceUnavailable, // 503
  unknown; // Outros erros ou status não tratados

  String get message {
    switch (this) {
      case HttpFailure.badRequest:
        return 'Requisição inválida. Por favor, verifique os dados enviados.';
      case HttpFailure.unauthorized:
        return 'Não autorizado. Verifique sua chave de API ou credenciais.';
      case HttpFailure.forbidden:
        return 'Acesso negado. Você não tem permissão para acessar este recurso.';
      case HttpFailure.notFound:
        return 'Recurso não encontrado. Verifique a URL ou o recurso solicitado.';
      case HttpFailure.internalServerError:
        return 'Erro interno no servidor. Tente novamente mais tarde.';
      case HttpFailure.serviceUnavailable:
        return 'Serviço indisponível. O servidor está temporariamente fora do ar.';
      case HttpFailure.unknown:
        return 'Ocorreu um erro desconhecido. Tente novamente.';
    }
  }
}
