import 'dart:convert';

import 'package:http/http.dart' as http;

class GeocodingResult {
  const GeocodingResult({
    required this.latitude,
    required this.longitude,
  });

  final double latitude;
  final double longitude;
}

class ReverseGeocodingResult {
  const ReverseGeocodingResult({
    this.comuna,
    this.region,
  });

  final String? comuna;
  final String? region;
}

/// Geocodificacion con Nominatim (OpenStreetMap). Gratuito, sin API key.
class GeocodingService {
  static const String _userAgent = 'EventosLoop/1.0 (loop.cl)';

  Future<GeocodingResult?> geocodeChileAddress({
    required String address,
    String? comuna,
    String? region,
  }) async {
    final List<String> parts = <String>[
      if (address.trim().isNotEmpty) address.trim(),
      if (comuna != null && comuna.trim().isNotEmpty) comuna.trim(),
      if (region != null && region.trim().isNotEmpty) region.trim(),
      'Chile',
    ];
    if (parts.length <= 1) {
      return null;
    }

    final Uri uri = Uri.https(
      'nominatim.openstreetmap.org',
      '/search',
      <String, String>{
        'q': parts.join(', '),
        'format': 'json',
        'limit': '1',
        'countrycodes': 'cl',
      },
    );

    final http.Response response = await http.get(
      uri,
      headers: <String, String>{'User-Agent': _userAgent},
    );
    if (response.statusCode != 200) {
      return null;
    }

    final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
    if (data.isEmpty) {
      return null;
    }

    final Map<String, dynamic> item = data.first as Map<String, dynamic>;
    final String? latRaw = item['lat'] as String?;
    final String? lonRaw = item['lon'] as String?;
    if (latRaw == null || lonRaw == null) {
      return null;
    }

    return GeocodingResult(
      latitude: double.parse(latRaw),
      longitude: double.parse(lonRaw),
    );
  }

  Future<ReverseGeocodingResult?> reverseGeocode({
    required double latitude,
    required double longitude,
  }) async {
    final Uri uri = Uri.https(
      'nominatim.openstreetmap.org',
      '/reverse',
      <String, String>{
        'lat': latitude.toString(),
        'lon': longitude.toString(),
        'format': 'json',
        'addressdetails': '1',
      },
    );

    final http.Response response = await http.get(
      uri,
      headers: <String, String>{'User-Agent': _userAgent},
    );
    if (response.statusCode != 200) {
      return null;
    }

    final Map<String, dynamic> data =
        jsonDecode(response.body) as Map<String, dynamic>;
    final Map<String, dynamic>? address =
        data['address'] as Map<String, dynamic>?;
    if (address == null) {
      return null;
    }

    final String? comuna = _firstNonEmpty(<String?>[
      address['city'] as String?,
      address['town'] as String?,
      address['municipality'] as String?,
      address['suburb'] as String?,
      address['county'] as String?,
    ]);
    final String? region = _firstNonEmpty(<String?>[
      address['state'] as String?,
      address['region'] as String?,
    ]);

    return ReverseGeocodingResult(comuna: comuna, region: region);
  }

  String? _firstNonEmpty(List<String?> values) {
    for (final String? value in values) {
      if (value != null && value.trim().isNotEmpty) {
        return value.trim();
      }
    }
    return null;
  }
}
