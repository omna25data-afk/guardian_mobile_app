import 'package:flutter/material.dart';

class RecordBook {
  final int id;
  final int bookNumber;
  final String name;
  final String contractTypeName;
  final int totalPages;
  final int constraintsCount;
  final int usedPercentage;
  final String statusLabel;
  final String statusColor; // 'success', 'danger' etc.

  RecordBook({
    required this.id,
    required this.bookNumber,
    required this.name,
    required this.contractTypeName,
    required this.totalPages,
    required this.constraintsCount,
    required this.usedPercentage,
    required this.statusLabel,
    required this.statusColor,
  });

  factory RecordBook.fromJson(Map<String, dynamic> json) {
    return RecordBook(
      id: json['id'] ?? 0,
      bookNumber: json['book_number'] ?? 0,
      name: json['name'] ?? '',
      contractTypeName: json['contract_type_name'] ?? '',
      totalPages: json['total_pages'] ?? 0,
      constraintsCount: json['constraints_count'] ?? 0,
      usedPercentage: json['used_percentage'] ?? 0,
      statusLabel: json['status_label'] ?? '',
      statusColor: json['status_color'] ?? 'grey',
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
