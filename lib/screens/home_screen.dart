import 'package:flutter/material.dart';
import '../services/transport_service.dart';
import '../services/location_service.dart';
import '../widgets/location_card.dart';
import '../widgets/station_search_bar.dart';
import '../widgets/nearby_stations_section.dart';
import '../widgets/quick_actions_section.dart';
import '../widgets/status_filter_section.dart';
import 'favorites_screen.dart';

const _primaryColor = Color(0xFF1A1A2E);
const _accentColor = Color(0xFFE94560);
const _bgColor = Color(0xFF16213E);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _transportService = TransportService();
  final _locationService = LocationService();

  List<String> _stations = [];
  bool _stationsLoading = true;
  String _locationText = 'Fetching location...';
  bool _locationLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStations();
    _loadLocation();
  }

  Future<void> _loadStations() async {
    try {
      final transports = await _transportService.fetchLiveData();
      final stationSet = <String>{
        for (final t in transports) ...{t.origin, t.destination}
      };
      if (mounted) setState(() { _stations = stationSet.toList()..sort(); _stationsLoading = false; });
    } catch (_) {
      if (mounted) setState(() => _stationsLoading = false);
    }
  }

  Future<void> _loadLocation() async {
    setState(() => _locationLoading = true);
    final text = await _locationService.fetchLocationText();
    if (mounted) setState(() { _locationText = text; _locationLoading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: _primaryColor,
        title: const Text('TransitTracker',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.star, color: _accentColor),
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => const FavoritesScreen())),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LocationCard(locationText: _locationText, isLoading: _locationLoading, onRefresh: _loadLocation),
            const SizedBox(height: 16),
            StationSearchBar(stations: _stations),
            const SizedBox(height: 24),
            NearbyStationsSection(stations: _stations, isLoading: _stationsLoading),
            const SizedBox(height: 24),
            const QuickActionsSection(),
            const SizedBox(height: 24),
            const StatusFilterSection(),
          ],
        ),
      ),
    );
  }
}
