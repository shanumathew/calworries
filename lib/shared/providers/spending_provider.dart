import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:calworries/features/shopping/data/models/spending_record.dart';
import 'package:calworries/core/services/hive_service.dart';
import 'package:intl/intl.dart';

class SpendingProvider extends ChangeNotifier {
  List<SpendingRecord> _records = [];

  List<SpendingRecord> get records => _records;

  SpendingProvider() {
    _loadRecords();
  }

  void _loadRecords() {
    try {
      final box = HiveService.getSpendingBox();
      _records = box.values.toList();
      _records.sort((a, b) => b.purchasedAt.compareTo(a.purchasedAt));
    } catch (e) {
      print('Error loading spending records: $e');
    }
  }

  Future<void> addRecord(SpendingRecord record) async {
    try {
      final box = HiveService.getSpendingBox();
      await box.put(record.id, record);
      _loadRecords();
      notifyListeners();
    } catch (e) {
      print('Error adding spending record: $e');
    }
  }

  Future<void> deleteRecord(String recordId) async {
    try {
      final box = HiveService.getSpendingBox();
      await box.delete(recordId);
      _loadRecords();
      notifyListeners();
    } catch (e) {
      print('Error deleting spending record: $e');
    }
  }

  double getMonthlySpending() {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    final monthEnd = DateTime(now.year, now.month + 1, 0);

    return _records
        .where(
          (record) =>
              record.purchasedAt.isAfter(monthStart) &&
              record.purchasedAt.isBefore(monthEnd),
        )
        .fold(0.0, (sum, record) => sum + record.totalCost);
  }

  double getWeeklySpending() {
    final now = DateTime.now();
    final weekAgo = now.subtract(Duration(days: 7));

    return _records
        .where(
          (record) =>
              record.purchasedAt.isAfter(weekAgo) &&
              record.purchasedAt.isBefore(now.add(Duration(days: 1))),
        )
        .fold(0.0, (sum, record) => sum + record.totalCost);
  }

  double getDailySpending(DateTime date) {
    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    return _records
        .where((record) {
          final recordDateStr = DateFormat(
            'yyyy-MM-dd',
          ).format(record.purchasedAt);
          return recordDateStr == dateStr;
        })
        .fold(0.0, (sum, record) => sum + record.totalCost);
  }

  Map<String, double> getSpendingByCategory() {
    final map = <String, double>{};
    for (final record in _records) {
      final categoryName = record.category.toString();
      map[categoryName] = (map[categoryName] ?? 0.0) + record.totalCost;
    }
    return map;
  }

  List<SpendingRecord> getRecordsByMonth(DateTime date) {
    final monthStart = DateTime(date.year, date.month, 1);
    final monthEnd = DateTime(date.year, date.month + 1, 0);
    return _records
        .where(
          (record) =>
              record.purchasedAt.isAfter(monthStart) &&
              record.purchasedAt.isBefore(monthEnd),
        )
        .toList();
  }
}
