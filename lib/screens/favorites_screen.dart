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
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => DetailScreen(transport: t)),
                  ).then((_) => _load()),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(color: _primaryColor, borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: _accentColor),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(t.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              Text('${t.origin} → ${t.destination}', style: const TextStyle(color: _greyText, fontSize: 13)),
                            ],
                          ),
                        ),
                        Text(t.arrivalTime, style: const TextStyle(color: _greyText)),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => _remove(t.id),
                          child: const Icon(Icons.delete_outline, color: _greyText),
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
