/// Representa erros retornados pelo servidor (ex: Erro 500).
class ServerException implements Exception {
  final String message;
  ServerException(this.message);
}

/// Representa falhas de conexão com a internet ou recursos não encontrados (ex: 404).
class NetworkException implements Exception {
  final String message;
  NetworkException({this.message = 'Sem conexão com a internet'});
}

/// Exceção genérica para erros inesperados não tratados especificamente.
class GeneralException implements Exception {
  final String message;
  GeneralException(this.message);
}