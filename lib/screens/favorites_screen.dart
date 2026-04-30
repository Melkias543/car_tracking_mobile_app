import 'package:flutter/material.dart';
import '../models/transport.dart';
import '../services/transport_service.dart';
import 'detail_screen.dart';

const _primaryColor = Color(0xFF1A1A2E);
const _accentColor = Color(0xFFE94560);
const _bgColor = Color(0xFF16213E);
const _greyText = Color(0xFF95A5A6);

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final _service = TransportService();
  List<Transport> _favorites = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final favs = await _service.getFavorites();
    if (mounted) setState(() => _favorites = favs);
  }

  Future<void> _remove(String id) async {
    await _service.removeFavorite(id);
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: _primaryColor,
        title: const Text('Favorites', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _favorites.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star_border, color: _greyText, size: 64),
                  SizedBox(height: 16),
                  Text('No favorites yet.', style: TextStyle(color: _greyText, fontSize: 16)),
                  SizedBox(height: 8),
                  Text('Tap ★ on a route to save it here.', style: TextStyle(color: _greyText)),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _favorites.length,
              separatorBuilder: (_, i) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final t = _favorites[i];
                final statusColor = t.status.toLowerCase() == 'delayed'
                    ? Colors.orange
                    : t.status.toLowerCase() == 'cancelled'
                        ? Colors.red
                        : Colors.green;
                final typeIcon = t.type.toLowerCase() == 'train'
                    ? Icons.train
                    : Icons.directions_bus;
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => DetailScreen(transport: t)),
                  ).then((_) => _load()),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: _primaryColor, borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      children: [
                        Icon(typeIcon, color: _accentColor, size: 32),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(t.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                              const SizedBox(height: 2),
                              Text('${t.origin} → ${t.destination}', style: const TextStyle(color: _greyText, fontSize: 13)),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: statusColor.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(t.status, style: TextStyle(color: statusColor, fontSize: 12)),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(t.arrivalTime, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () => _remove(t.id),
                              child: const Icon(Icons.delete_outline, color: _greyText),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
