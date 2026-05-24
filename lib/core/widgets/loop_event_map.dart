import 'package:eventosloop/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class LoopEventMap extends StatelessWidget {
  const LoopEventMap({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.locationName,
    required this.address,
  });

  final double latitude;
  final double longitude;
  final String locationName;
  final String address;

  LatLng get _center => LatLng(latitude, longitude);

  Future<void> _openInMaps() async {
    final Uri uri = Uri.parse(
      'https://www.openstreetmap.org/?mlat=$latitude&mlon=$longitude#map=16/$latitude/$longitude',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            height: 180,
            width: double.infinity,
            child: FlutterMap(
              options: MapOptions(
                initialCenter: _center,
                initialZoom: 15,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                ),
              ),
              children: <Widget>[
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.eventosloop.app',
                ),
                MarkerLayer(
                  markers: <Marker>[
                    Marker(
                      point: _center,
                      width: 42,
                      height: 42,
                      child: const Icon(
                        Icons.location_on,
                        color: AppColors.primary,
                        size: 42,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    locationName,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    address,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            TextButton.icon(
              onPressed: _openInMaps,
              icon: const Icon(Icons.open_in_new, size: 16),
              label: const Text('Abrir mapa'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
