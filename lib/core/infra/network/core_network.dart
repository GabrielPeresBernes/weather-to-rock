/// Perform http network requests
abstract interface class CoreNetwork {
  /// Performs a GET request.
  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, String>? headers,
    Map<String, String>? queryParams,
  });
}
