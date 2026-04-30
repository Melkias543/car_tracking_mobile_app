import 'package:flutter/material.dart';
import 'station_card.dart';

const _accentColor = Color(0xFFE94560);
const _greyText = Color(0xFF95A5A6);

class NearbyStationsSection extends StatelessWidget {
  final List<String> stations;
  final bool isLoading;

  const NearbyStationsSection({
    super.key,
    required this.stations,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Nearby Stations',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        SizedBox(
          height: 90,
          child: isLoading
              ? const Center(child: CircularProgressIndicator(color: _accentColor))
              : stations.isEmpty
                  ? const Center(child: Text('No stations found.', style: TextStyle(color: _greyText)))
                  : ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: stations.length,
                      separatorBuilder: (_, i) => const SizedBox(width: 12),
                      itemBuilder: (context, i) => StationCard(name: stations[i]),
                    ),
        ),
      ],
    );
  }
}
