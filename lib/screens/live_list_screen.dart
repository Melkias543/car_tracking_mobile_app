import 'package:flutter/material.dart';
import '../models/transport.dart';
import '../services/transport_service.dart';
import 'detail_screen.dart';

const _primaryColor = Color(0xFF1A1A2E);
const _accentColor = Color(0xFFE94560);
const _bgColor = Color(0xFF16213E);
const _greyText = Color(0xFF95A5A6);

class LiveListScreen extends StatefulWidget {
  final String? statusFilter;
  const LiveListScreen({super.key, this.statusFilter});

  @override
  State<LiveListScreen> createState() => _LiveListScreenState();
}

class _LiveListScreenState extends State<LiveListScreen> {
  final _service = TransportService();
  late Future<List<Transport>> _future;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _future = _service.fetchLiveData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: _primaryColor,
        title: Text(
            widget.statusFilter != null
                ? '${widget.statusFilter![0].toUpperCase()}${widget.statusFilter!.substring(1)} Routes'
                : 'Live Arrivals',
            style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(icon: const Icon(Icons.refresh, color: _accentColor), onPressed: _load),
        ],
      ),
      body: FutureBuilder<List<Transport>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: _accentColor));
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.white)));
          }
          final allItems = snapshot.data ?? [];
          final items = widget.statusFilter == null
              ? allItems
              : allItems.where((t) => t.status.toLowerCase() == widget.statusFilter).toList();
          if (items.isEmpty) {
            return Center(
              child: Text(
                widget.statusFilter != null
                    ? 'No ${widget.statusFilter} routes found.'
                    : 'No arrivals found.',
                style: const TextStyle(color: _greyText),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (_, i) => const SizedBox(height: 10),
            itemBuilder: (context, i) => _TransportTile(transport: items[i]),
          );
        },
      ),
    );
  }
}

class _TransportTile extends StatefulWidget {
  final Transport transport;
  const _TransportTile({required this.transport});

  @override
  State<_TransportTile> createState() => _TransportTileState();
}

class _TransportTileState extends State<_TransportTile> {
  final _service = TransportService();
  bool _isFav = false;

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
    } else {
      await _service.saveFavorite(widget.transport);
    }
    if (mounted) setState(() => _isFav = !_isFav);
  }

  Color get _statusColor {
    switch (widget.transport.status.toLowerCase()) {
      case 'delayed': return Colors.orange;
      case 'cancelled': return Colors.red;
      default: return Colors.green;
    }
  }

  IconData get _typeIcon {
    switch (widget.transport.type.toLowerCase()) {
      case 'train': return Icons.train;
      case 'metro': return Icons.subway;
      default: return Icons.directions_bus;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailScreen(transport: widget.transport)))
          .then((_) => _checkFav()),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: _primaryColor, borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Icon(_typeIcon, color: _accentColor, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.transport.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  Text('${widget.transport.origin} → ${widget.transport.destination}', style: const TextStyle(color: _greyText)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(widget.transport.arrivalTime, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: _statusColor.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
                  child: Text(widget.transport.status, style: TextStyle(color: _statusColor, fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _toggleFav,
              child: Icon(_isFav ? Icons.star : Icons.star_border, color: _accentColor, size: 26),
            ),
          ],
        ),
      ),
    );
  }
}
