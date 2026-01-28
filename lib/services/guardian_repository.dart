import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:guardian_app/models/dashboard_data.dart';
import 'package:guardian_app/models/record_book.dart';
import 'package:guardian_app/models/registry_entry.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class GuardianRepository {
  // Use the base URL from the new developer guide
  final String _baseUrl = "https://your-domain.com/api";
  final _secureStorage = const FlutterSecureStorage();

  Future<String?> _getAuthToken() async {
    // This should be replaced with your actual token retrieval logic
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

  Future<DashboardData> getDashboard() async {
    final url = Uri.parse('$_baseUrl/dashboard');
    final headers = await _getJsonHeaders();

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        // Decode response using utf8 to handle Arabic characters correctly
        final data = json.decode(utf8.decode(response.bodyBytes));
        return DashboardData.fromJson(data);
      } else {
        throw Exception('Failed to load dashboard data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load dashboard data: $e');
    }
  }

  Future<List<RecordBook>> getRecordBooks() async {
    final url = Uri.parse('$_baseUrl/record-books');
    final headers = await _getJsonHeaders();

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        return data.map((json) => RecordBook.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load record books: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load record books: $e');
    }
  }
  
  Future<List<RegistryEntry>> getRegistryEntries({String? status, String? searchQuery}) async {
    var queryParams = {
      'status': status,
      'search': searchQuery,
    };
    queryParams.removeWhere((key, value) => value == null);
    
    final url = Uri.parse('$_baseUrl/registry-entries').replace(queryParameters: queryParams);
    final headers = await _getJsonHeaders();

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        return data.map((json) => RegistryEntry.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load registry entries: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load registry entries: $e');
    }
  }

  /// Creates a new draft entry.
  /// The `entryData` map must contain the fields specified in the API documentation
  /// for the POST /registry-entries endpoint.
  Future<RegistryEntry> createEntry(Map<String, String> entryData) async {
    final url = Uri.parse('$_baseUrl/registry-entries');
    final token = await _getAuthToken();

    // Headers for Form Data are different from JSON
    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      // http package sets 'Content-Type' to 'application/x-www-form-urlencoded' automatically for a Map<String, String> body
    };

    try {
      // Send as Form Data (x-www-form-urlencoded)
      final response = await http.post(url, headers: headers, body: entryData);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        return RegistryEntry.fromJson(data);
      } else {
        // You might want to parse the error body for more details
        throw Exception('Failed to create entry: ${response.statusCode}, Body: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to create entry: $e');
    }
  }
}
