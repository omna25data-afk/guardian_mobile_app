import 'package:flutter/material.dart';
import './registry_entry.dart';

// A helper function to safely parse dates
DateTime? _safeParseDate(String? dateStr) {
  if (dateStr == null) return null;
  try {
    return DateTime.parse(dateStr);
  } catch (e) {
    return null;
  }
}

// A helper function to map status colors
Color _mapStatusColor(String? colorName) {
  switch (colorName) {
    case 'success':
      return Colors.green;
    case 'warning':
      return Colors.orange;
    case 'danger':
      return Colors.red;
    default:
      return Colors.grey;
  }
}

class DashboardData {
  final String welcomeMessage;
  final String dateGregorian;
  final String dateHijri;
  final DashboardStats stats;
  final GuardianRenewalStatus licenseStatus;
  final GuardianRenewalStatus cardStatus;
  final List<RegistryEntry> recentActivities;
  final int unreadNotifications;

  DashboardData({
    required this.welcomeMessage,
    required this.dateGregorian,
    required this.dateHijri,
    required this.stats,
    required this.licenseStatus,
    required this.cardStatus,
    required this.recentActivities,
    required this.unreadNotifications,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    final meta = json['meta'] ?? {};
    final statsData = json['stats'] ?? {};
    final statusSummary = json['status_summary'] ?? {};
    final license = statusSummary['license'] ?? {};
    final card = statusSummary['card'] ?? {};
    final activities = json['recent_activities'] as List?;

    return DashboardData(
      welcomeMessage: meta['welcome_message'] ?? '',
      dateGregorian: meta['date_gregorian'] ?? '',
      dateHijri: meta['date_hijri'] ?? '',
      stats: DashboardStats.fromJson(statsData),
      licenseStatus: GuardianRenewalStatus.fromJson(license),
      cardStatus: GuardianRenewalStatus.fromJson(card),
      recentActivities: activities?.map((e) => RegistryEntry.fromJson(e)).toList() ?? [],
      unreadNotifications: json['unread_notifications_count'] ?? 0,
    );
  }
}

class DashboardStats {
  final int totalEntries;
  final int totalDrafts;
  final int totalDocumented;
  final int thisMonthEntries;

  DashboardStats({
    required this.totalEntries,
    required this.totalDrafts,
    required this.totalDocumented,
    required this.thisMonthEntries,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      totalEntries: json['total_entries'] ?? 0,
      totalDrafts: json['total_drafts'] ?? 0,
      totalDocumented: json['total_documented'] ?? 0,
      thisMonthEntries: json['this_month_entries'] ?? 0,
    );
  }
}

class GuardianRenewalStatus {
  final String label;
  final Color color;
  final DateTime? expiryDate;
  final int? daysRemaining;

  GuardianRenewalStatus({
    required this.label,
    required this.color,
    this.expiryDate,
    this.daysRemaining,
  });

  factory GuardianRenewalStatus.fromJson(Map<String, dynamic> json) {
    return GuardianRenewalStatus(
      label: json['status_label'] ?? 'غير متوفر',
      color: _mapStatusColor(json['status_color']),
      expiryDate: _safeParseDate(json['expiry_date']),
      daysRemaining: json['days_remaining'],
    );
  }
}
