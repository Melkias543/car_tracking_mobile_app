import 'package:flutter/material.dart';
import 'action_buttons.dart';
import '../screens/live_list_screen.dart';

class StatusFilterSection extends StatelessWidget {
  const StatusFilterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Filter by Status',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: StatusButton(
                label: 'On Time',
                color: Colors.green,
                icon: Icons.check_circle_outline,
                onTap: () => Navigator.push(context, MaterialPageRoute(
                  builder: (_) => const LiveListScreen(statusFilter: 'on time'),
                )),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: StatusButton(
                label: 'Delayed',
                color: Colors.orange,
                icon: Icons.access_time,
                onTap: () => Navigator.push(context, MaterialPageRoute(
                  builder: (_) => const LiveListScreen(statusFilter: 'delayed'),
                )),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: StatusButton(
                label: 'Cancelled',
                color: Colors.red,
                icon: Icons.cancel_outlined,
                onTap: () => Navigator.push(context, MaterialPageRoute(
                  builder: (_) => const LiveListScreen(statusFilter: 'cancelled'),
                )),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
