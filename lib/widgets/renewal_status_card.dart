import 'package:flutter/material.dart';
import 'package:guardian_app/models/dashboard_data.dart';

class RenewalStatusCard extends StatelessWidget {
  final String title;
  final StatusSummaryItem status;

  // FIX: Use const and super parameters
  const RenewalStatusCard({super.key, required this.title, required this.status});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = status.color;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        // FIX: Added const
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            Icon(Icons.shield_outlined, color: color, size: 32),
            // FIX: Added const
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  // FIX: Added const
                  const SizedBox(height: 4),
                  Text(
                    status.statusLabel,
                    style: theme.textTheme.bodyMedium?.copyWith(color: color, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            if (status.daysRemaining != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                    Text(
                        '${status.daysRemaining} يوماً',
                        style: theme.textTheme.titleMedium?.copyWith(color: color, fontWeight: FontWeight.bold),
                    ),
                    // FIX: Added const
                    const Text(
                        'متبقي',
                        style: TextStyle(fontSize: 12), // Adjusted for consistency
                    ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
