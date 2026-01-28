import 'package:flutter/material.dart';

// Helper function to map status color strings to Material Colors
Color _mapStatusColor(String? colorName) {
  switch (colorName) {
    case 'success':
      return Colors.green;
    case 'warning':
      return Colors.orange;
    case 'danger':
      return Colors.red;
    default:
      return Colors.grey; // A sensible default
  }
}

/// Represents a record book as defined by the API.
/// It uses clean, developer-friendly field names.
class RecordBook {
  final int id;
  final int number;           // Mapped from 'book_number'
  final String title;          // Mapped from 'name'
  final String contractType;   // Mapped from 'contract_type_name'
  final int totalPages;
  final int usedPages;        // Mapped from 'constraints_count'
  final int usagePercentage;  // Mapped from 'used_percentage'
  final String statusLabel;
  final Color statusColor;

  RecordBook({
    required this.id,
    required this.number,
    required this.title,
    required this.contractType,
    required this.totalPages,
    required this.usedPages,
    required this.usagePercentage,
    required this.statusLabel,
    required this.statusColor,
  });

  /// Factory constructor to create a RecordBook instance from a JSON map.
  factory RecordBook.fromJson(Map<String, dynamic> json) {
    return RecordBook(
      id: json['id'] ?? 0,
      number: json['book_number'] ?? 0,
      title: json['name'] ?? 'غير معنون', // Default title
      contractType: json['contract_type_name'] ?? 'غير محدد',
      totalPages: json['total_pages'] ?? 0,
      usedPages: json['constraints_count'] ?? 0, // Aliased as per instruction
      usagePercentage: (json['used_percentage'] as num?)?.toInt() ?? 0,
      statusLabel: json['status_label'] ?? 'غير معروف',
      statusColor: _mapStatusColor(json['status_color']),
    );
  }
}
