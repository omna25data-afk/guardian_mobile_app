import 'package:flutter/material.dart';

// A helper function to map status colors
Color _mapStatusColor(String? colorName) {
  switch (colorName) {
    case 'success':
      return Colors.green;
    case 'warning':
      return Colors.orange;
    case 'danger':
      return Colors.red;
    case 'draft':
      return Colors.grey;
    default:
      return Colors.blue;
  }
}

class RegistryEntry {
  final int id;
  final int? serialNumber;
  final String status;
  final String statusLabel;
  final Color statusColor;
  final String firstParty;
  final String secondParty;
  final String contractType;
  final String dateHijri;
  final String dateGregorian;
  final double totalFees;
  final bool isPaid;

  RegistryEntry({
    required this.id,
    this.serialNumber,
    required this.status,
    required this.statusLabel,
    required this.statusColor,
    required this.firstParty,
    required this.secondParty,
    required this.contractType,
    required this.dateHijri,
    required this.dateGregorian,
    required this.totalFees,
    required this.isPaid,
  });

  factory RegistryEntry.fromJson(Map<String, dynamic> json) {
    final contract = json['contract_type'] ?? {};
    final docDate = json['document_date'] ?? {};
    final fees = json['fees'] ?? {};

    return RegistryEntry(
      id: json['id'] ?? 0,
      serialNumber: json['serial_number'],
      status: json['status'] ?? 'unknown',
      statusLabel: json['status_label'] ?? 'غير معروف',
      statusColor: _mapStatusColor(json['status_color']),
      firstParty: json['first_party_name'] ?? '',
      secondParty: json['second_party_name'] ?? '',
      contractType: contract['name'] ?? '',
      dateHijri: docDate['hijri'] ?? '',
      dateGregorian: docDate['gregorian'] ?? '',
      totalFees: (fees['total'] as num?)?.toDouble() ?? 0.0,
      isPaid: fees['is_paid'] ?? false,
    );
  }
}
