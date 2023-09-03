// Copyright (c) 2023, Halil Durmus. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

/// Exception thrown when a server returns *non-200* status code.
final class NuGetServerException implements Exception {
  const NuGetServerException(this.message);

  final String message;

  @override
  String toString() => 'NuGetServerException: $message';
}
