import 'package:flutter/material.dart';

const _primaryColor = Color(0xFF1A1A2E);
const _accentColor = Color(0xFFE94560);
const _greyText = Color(0xFF95A5A6);

class LocationCard extends StatelessWidget {
  final String locationText;
  final bool isLoading;
  final VoidCallback onRefresh;

  const LocationCard({
    super.key,
    required this.locationText,
    required this.isLoading,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: _primaryColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _accentColor.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.my_location, color: _accentColor),
          const SizedBox(width: 12),
          Expanded(
            child: isLoading
                ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(color: _accentColor, strokeWidth: 2),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Your Location', style: TextStyle(color: _greyText, fontSize: 12)),
                      Text(locationText, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ],
                  ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: _greyText, size: 20),
            onPressed: onRefresh,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
