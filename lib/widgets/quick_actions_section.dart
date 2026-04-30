import 'package:flutter/material.dart';
import 'action_buttons.dart';
import '../screens/live_list_screen.dart';
import '../screens/favorites_screen.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Quick Actions',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ActionButton(
                icon: Icons.directions_bus,
                label: 'Live Arrivals',
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const LiveListScreen())),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ActionButton(
                icon: Icons.star_border,
                label: 'Favorites',
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const FavoritesScreen())),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
