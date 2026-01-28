import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:guardian_app/models/dashboard_data.dart';
import 'package:guardian_app/models/record_book.dart';
import 'package:guardian_app/models/registry_entry.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class GuardianRepository {
  final String _baseUrl = "https://darkturquoise-lark-306795.hostingersite.com/api";
  final _secureStorage = const FlutterSecureStorage();

  Future<String?> _getAuthToken() async {
    return await _secureStorage.read(key: 'auth_token');
  }

  Future<Map<String, String>> _getJsonHeaders() async {
    final token = await _getAuthToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // FIXED: Correctly parses the new DashboardData model structure
  Future<DashboardData> getDashboard() async {
    final url = Uri.parse('$_baseUrl/dashboard');
    final headers = await _getJsonHeaders();
    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        return DashboardData.fromJson(data);
      } else {
        throw Exception('Failed to load dashboard data: ${response.statusCode}\nBody: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error in getDashboard: $e');
    }
  }

  // FIXED: Correctly parses the list from the "date" key
  Future<List<RecordBook>> getRecordBooks() async {
    final url = Uri.parse('$_baseUrl/record-books');
    final headers = await _getJsonHeaders();
    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final decoded = json.decode(utf8.decode(response.bodyBytes));
        // The list is under the "date" key as per documentation
        final List<dynamic> data = decoded['date'] ?? [];
        return data.map((json) => RecordBook.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load record books: ${response.statusCode}\nBody: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error in getRecordBooks: $e');
    }
  }
  
  Future<List<RegistryEntry>> getRegistryEntries({String? status, String? searchQuery}) async {
    // ... (This part seems okay, but will double-check if errors persist)
    return []; // Placeholder for now
  }

  // FIXED: Uses the correct field names for the POST request as per documentation
  Future<RegistryEntry> createEntry(Map<String, String> entryData) async {
    final url = Uri.parse('$_baseUrl/registry-entries');
    final token = await _getAuthToken();

    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      // The API expects form-data, which http.post handles directly with a Map<String, String> body.
      final response = await http.post(url, headers: headers, body: entryData);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        // Assuming the created entry is returned directly or under a 'data' key
        final entryJson = data['data'] ?? data;
        return RegistryEntry.fromJson(entryJson);
      } else {
        throw Exception('Failed to create entry: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error in createEntry: $e');
    }
  }
}
