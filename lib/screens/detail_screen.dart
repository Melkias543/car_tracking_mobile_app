import 'package:flutter/material.dart';
import '../models/transport.dart';
import '../services/transport_service.dart';

const _primaryColor = Color(0xFF1A1A2E);
const _accentColor = Color(0xFFE94560);
const _bgColor = Color(0xFF16213E);
const _greyText = Color(0xFF95A5A6);

class DetailScreen extends StatefulWidget {
  final Transport transport;
  const DetailScreen({super.key, required this.transport});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final _service = TransportService();
  bool _isFav = false;

  List<String> get _stops => [widget.transport.origin, widget.transport.destination];

  @override
  void initState() {
    super.initState();
    _checkFav();
  }

  Future<void> _checkFav() async {
    final fav = await _service.isFavorite(widget.transport.id);
    if (mounted) setState(() => _isFav = fav);
  }

  Future<void> _toggleFav() async {
    if (_isFav) {
      await _service.removeFavorite(widget.transport.id);
      if (mounted) {
        setState(() => _isFav = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${widget.transport.name} removed from favorites'), backgroundColor: Colors.grey[800]),
        );
      }
    } else {
      await _service.saveFavorite(widget.transport);
      if (mounted) {
        setState(() => _isFav = true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${widget.transport.name} saved to favorites!'), backgroundColor: _accentColor),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: _primaryColor,
        title: Text(widget.transport.name, style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(_isFav ? Icons.star : Icons.star_border, color: _accentColor),
            onPressed: _toggleFav,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _InfoCard(transport: widget.transport),
            const SizedBox(height: 24),
            const Text('Route Stops', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: _stops.length,
                itemBuilder: (context, i) => _StopTile(
                  stop: _stops[i],
                  isFirst: i == 0,
                  isLast: i == _stops.length - 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final Transport transport;
  const _InfoCard({required this.transport});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: _primaryColor, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(transport.name, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _InfoRow(icon: Icons.location_on, label: 'Destination', value: transport.destination),
          _InfoRow(icon: Icons.trip_origin, label: 'Origin', value: transport.origin),
          _InfoRow(icon: Icons.access_time, label: 'Arrival', value: transport.arrivalTime),
          _InfoRow(icon: Icons.info_outline, label: 'Status', value: transport.status),
          _InfoRow(icon: Icons.directions_bus, label: 'Type', value: transport.type.toUpperCase()),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: _accentColor, size: 18),
          const SizedBox(width: 8),
          Text('$label: ', style: const TextStyle(color: _greyText)),
          Text(value, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}

class _StopTile extends StatelessWidget {
  final String stop;
  final bool isFirst;
  final bool isLast;
  const _StopTile({required this.stop, required this.isFirst, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            Container(width: 2, height: 16, color: isFirst ? Colors.transparent : _accentColor),
            Container(width: 12, height: 12, decoration: const BoxDecoration(shape: BoxShape.circle, color: _accentColor)),
            Container(width: 2, height: 16, color: isLast ? Colors.transparent : _accentColor),
          ],
        ),
        const SizedBox(width: 16),
        Text(stop, style: const TextStyle(color: Colors.white, fontSize: 15)),
      ],
    );
  }
}
