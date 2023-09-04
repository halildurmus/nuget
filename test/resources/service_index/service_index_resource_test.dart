// Copyright (c) 2023, Halil Durmus. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:checks/checks.dart';
import 'package:http/http.dart' as http;
import 'package:nuget/nuget.dart';
import 'package:test/scaffolding.dart';

void main() async {
  group('ServiceIndexResource', () {
    late final http.Client httpClient;
    late final ServiceIndexResource resource;

    setUpAll(() {
      httpClient = http.Client();
      return resource = ServiceIndexResource(
        httpClient: httpClient,
        resourceUri: ServiceIndexResource.nugetOrgServiceIndex,
      );
    });

    test('get returns all resources', () async {
      final serviceIndexResponse = await resource.get();
      check(serviceIndexResponse)
        ..has((e) => e.version, 'version').equals('3.0.0')
        ..has((e) => e.resources, 'resources').isNotEmpty()
        ..has((e) => e.catalogResourceUri, 'catalogResourceUri').isNotNull()
        ..has((e) => e.packageContentResourceUri, 'packageContentResourceUri')
            .isNotNull()
        ..has((e) => e.packageMetadataResourceUri, 'packageMetadataResourceUri')
            .isNotNull()
        ..has((e) => e.searchAutocompleteResourceUri,
                'searchAutocompleteResourceUri')
            .isNotNull()
        ..has((e) => e.searchQueryResourceUri, 'searchQueryResourceUri')
            .isNotNull();
      check(() => serviceIndexResponse
              .getRequiredResourceUri(['NonExistingResource']))
          .throws<NuGetServerException>()
        ..has((e) => e.message, 'message').equals(
            'The service index does not have a resource named `NonExistingResource`.')
        ..has((e) => e.toString(), 'toString').equals(
            'NuGetServerException: The service index does not have a resource named `NonExistingResource`.');
    });

    tearDownAll(() => resource.close());
  });
}
