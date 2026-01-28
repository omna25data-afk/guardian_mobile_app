import 'package:flutter/material.dart';
import 'package:guardian_app/models/dashboard_data.dart';
import 'package:guardian_app/services/guardian_repository.dart';

class HomeScreenProvider with ChangeNotifier {
  final GuardianRepository _repository = GuardianRepository();

  DashboardData? _dashboardData;
  DashboardData? get dashboardData => _dashboardData;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchDashboardData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _dashboardData = await _repository.getDashboard();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
