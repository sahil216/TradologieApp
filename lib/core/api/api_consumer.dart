abstract class ApiConsumer {
  Future<dynamic> get(String path, {Map<String, dynamic>? queryParameters});
  Future<dynamic> post(String path,
      {Map<String, dynamic>? body,
      bool formDataIsEnabled = false,
      Map<String, dynamic>? queryParameters});

  /// Supplier APIs that return `{ "Result": { "success", "message", ... } }`.
  Future<dynamic> postSupplierResult(String path,
      {Map<String, dynamic>? body});
  Future<dynamic> put(String path,
      {Map<String, dynamic>? body, Map<String, dynamic>? queryParameters});
  Future<dynamic> delete(String path,
      {Map<String, dynamic>? body, Map<String, dynamic>? queryParameters});
}
