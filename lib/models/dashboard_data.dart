import 'package:flutter/material.dart';

// Main model for the /dashboard endpoint response
class DashboardData {
  final Meta meta;
  final Stats stats;
  final StatusSummary statusSummary;

  DashboardData({
    required this.meta,
    required this.stats,
    required this.statusSummary,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      meta: Meta.fromJson(json['meta'] ?? {}),
      stats: Stats.fromJson(json['stats'] ?? {}),
      statusSummary: StatusSummary.fromJson(json['status_summary'] ?? {}),
    );
  }
}

// Corresponds to the "meta" object in the JSON
class Meta {
  final String welcomeMessage;
  final String dateGregorian;
  final String dateHijri;

  Meta({
    required this.welcomeMessage,
    required this.dateGregorian,
    required this.dateHijri,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      welcomeMessage: json['welcome_message'] ?? 'مرحباً',
      dateGregorian: json['date_gregorian'] ?? '',
      dateHijri: json['date_hijri'] ?? '',
    );
  }
}

// Corresponds to the "stats" object in the JSON
class Stats {
  final int totalEntries;
  final int totalDrafts;
  final int totalDocumented;
  final int thisMonthEntries;

  Stats({
    required this.totalEntries,
    required this.totalDrafts,
    required this.totalDocumented,
    required this.thisMonthEntries,
  });

  factory Stats.fromJson(Map<String, dynamic> json) {
    return Stats(
      totalEntries: json['total_entries'] ?? 0,
      totalDrafts: json['total_drafts'] ?? 0,
      totalDocumented: json['total_documented'] ?? 0,
      thisMonthEntries: json['this_month_entries'] ?? 0,
    );
  }
}

// Corresponds to the "status_summary" object
class StatusSummary {
  final StatusSummaryItem license;
  final StatusSummaryItem card;

  StatusSummary({required this.license, required this.card});

  factory StatusSummary.fromJson(Map<String, dynamic> json) {
    return StatusSummary(
      license: StatusSummaryItem.fromJson(json['license'] ?? {}),
      card: StatusSummaryItem.fromJson(json['card'] ?? {}),
    );
  }
}

// Represents a single status item (license or card)
class StatusSummaryItem {
  final String statusLabel;
  final String statusColor; // e.g., 'success', 'danger'
  final String expiryDate;
  final int? daysRemaining;

  StatusSummaryItem({
    required this.statusLabel,
    required this.statusColor,
    required this.expiryDate,
    this.daysRemaining,
  });

  factory StatusSummaryItem.fromJson(Map<String, dynamic> json) {
    return StatusSummaryItem(
      statusLabel: json['status_label'] ?? 'غير معروف',
      statusColor: json['status_color'] ?? 'grey',
      expiryDate: json['expiry_date'] ?? '',
      // FIXED: Corrected syntax error and added type casting
      daysRemaining: json['days_remaining'] as int?,
    );
  }

  // FIXED: Renamed getter from a_color to color for convention
  Color get color {
    switch (statusColor) {
      case 'success':
        return Colors.green;
      case 'danger':
        return Colors.red;
      case 'warning':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
