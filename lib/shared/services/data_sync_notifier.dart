import 'package:flutter/material.dart';

class DataSyncNotifier extends ChangeNotifier {
  static final DataSyncNotifier _instance = DataSyncNotifier._internal();
  factory DataSyncNotifier() => _instance;
  DataSyncNotifier._internal();

  void notifyAccountChange() {
    notifyListeners();
  }

  void notifyTransactionChange() {
    notifyListeners();
  }

  void notifyCategoryChange() {
    notifyListeners();
  }
}

final dataSyncNotifier = DataSyncNotifier();
