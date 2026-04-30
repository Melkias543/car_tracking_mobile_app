import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transport.dart';

class TransportService {
  static const _apiUrl = 'https://api.npoint.io/0240de8bc22e678b690e';
  static const _favsKey = 'favs';

  Future<List<Transport>> fetchLiveData() async {
    final response = await http.get(Uri.parse(_apiUrl));
    if (response.statusCode == 200) {
      final List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Transport.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load transport data (${response.statusCode})');
    }
  }

  Future<List<Transport>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_favsKey) ?? [];
    return raw.map(Transport.fromJsonString).toList();
  }

  Future<bool> isFavorite(String id) async {
    final favs = await getFavorites();
    return favs.any((t) => t.id == id);
  }

  Future<void> saveFavorite(Transport transport) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_favsKey) ?? [];
    if (!raw.any((s) => Transport.fromJsonString(s).id == transport.id)) {
      raw.add(transport.toJsonString());
      await prefs.setStringList(_favsKey, raw);
    }
  }

  Future<void> removeFavorite(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_favsKey) ?? [];
    raw.removeWhere((s) => Transport.fromJsonString(s).id == id);
    await prefs.setStringList(_favsKey, raw);
  }
}
