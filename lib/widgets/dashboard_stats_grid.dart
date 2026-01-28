import 'package:flutter/material.dart';
import 'package:guardian_app/models/dashboard_data.dart';

class DashboardStatsGrid extends StatelessWidget {
  final Stats stats;

  // FIX: Use const and super parameters
  const DashboardStatsGrid({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      // FIX: Added const
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 2.5,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      children: [
        _buildStatCard(context, 'إجمالي السجلات', stats.totalEntries.toString(), Icons.book_outlined),
        _buildStatCard(context, 'مسودات', stats.totalDrafts.toString(), Icons.drafts_outlined),
        _buildStatCard(context, 'سجلات مكتملة', stats.totalDocumented.toString(), Icons.check_circle_outline),
        _buildStatCard(context, 'هذا الشهر', stats.thisMonthEntries.toString(), Icons.calendar_today_outlined),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        // FIX: Added const
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: theme.primaryColor, size: 22),
            // FIX: Added const
            const SizedBox(height: 8),
            Text(title, style: theme.textTheme.bodySmall, overflow: TextOverflow.ellipsis),
            // FIX: Added const
            const SizedBox(height: 2),
            Text(value, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
