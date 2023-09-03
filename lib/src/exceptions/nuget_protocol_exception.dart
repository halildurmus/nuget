class NuGetProtocolException implements Exception {
  const NuGetProtocolException(this.message);

  final String message;

  @override
  String toString() => 'NuGetProtocolException: $message';
}
