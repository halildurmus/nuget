final class PackageNotFoundException implements Exception {
  const PackageNotFoundException(this.packageId, [this.packageVersion]);

  final String packageId;
  final String? packageVersion;

  String get message => packageVersion != null
      ? 'Package `$packageId` v$packageVersion not found.'
      : 'Package `$packageId` not found.';

  @override
  String toString() => 'PackageNotFoundException: $message';
}
