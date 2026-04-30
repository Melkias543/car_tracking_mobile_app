import 'package:flutter/material.dart';

const _primaryColor = Color(0xFF1A1A2E);
const _accentColor = Color(0xFFE94560);
const _greyText = Color(0xFF95A5A6);

class StationSearchBar extends StatefulWidget {
  final List<String> stations;

  const StationSearchBar({super.key, required this.stations});

  @override
  State<StationSearchBar> createState() => _StationSearchBarState();
}

class _StationSearchBarState extends State<StationSearchBar> {
  final _controller = TextEditingController();
  List<String> _results = [];

  void _onChanged(String query) {
    setState(() {
      _results = query.isEmpty
          ? []
          : widget.stations
              .where((s) => s.toLowerCase().contains(query.toLowerCase()))
              .toList();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          onChanged: _onChanged,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search stations or routes...',
            hintStyle: const TextStyle(color: _greyText),
            prefixIcon: const Icon(Icons.search, color: _greyText),
            filled: true,
            fillColor: _primaryColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        if (_results.isNotEmpty)
          Container(
            color: _primaryColor,
            child: Column(
              children: _results
                  .map((s) => ListTile(
                        title: Text(s, style: const TextStyle(color: Colors.white)),
                        leading: const Icon(Icons.location_on, color: _accentColor),
                        onTap: () {
                          _controller.clear();
                          setState(() => _results = []);
                        },
                      ))
                  .toList(),
            ),
          ),
      ],
    );
  }
}
