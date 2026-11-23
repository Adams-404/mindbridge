import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckInEntry {
  const CheckInEntry({
    required this.id,
    required this.timestamp,
    required this.mood,
    required this.symbol,
    required this.score,
    required this.note,
    required this.factors,
  });

  final String id;
  final DateTime timestamp;
  final String mood;
  final String symbol;
  final int score; // 1 to 5
  final String note;
  final List<String> factors;

  Map<String, dynamic> toJson() => {
        'id': id,
        'timestamp': timestamp.toIso8601String(),
        'mood': mood,
        'symbol': symbol,
        'score': score,
        'note': note,
        'factors': factors,
      };

  factory CheckInEntry.fromJson(Map<String, dynamic> json) => CheckInEntry(
        id: json['id'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString(),
        timestamp: DateTime.tryParse(json['timestamp'] as String? ?? '') ?? DateTime.now(),
        mood: json['mood'] as String? ?? 'Calm',
        symbol: json['symbol'] as String? ?? '◒',
        score: json['score'] as int? ?? 3,
        note: json['note'] as String? ?? '',
        factors: (json['factors'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
      );
}

abstract interface class CheckInRepository {
  Future<List<CheckInEntry>> getEntries();
  Future<void> addEntry(CheckInEntry entry);
  Future<void> deleteEntry(String id);
  Future<void> clearAll();
}

class SharedPrefsCheckInRepository implements CheckInRepository {
  static const _storageKey = 'mindbridge_check_in_history';

  @override
  Future<List<CheckInEntry>> getEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_storageKey);
    if (raw == null || raw.isEmpty) return [];
    return raw
        .map((item) {
          try {
            return CheckInEntry.fromJson(jsonDecode(item) as Map<String, dynamic>);
          } catch (_) {
            return null;
          }
        })
        .whereType<CheckInEntry>()
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  @override
  Future<void> addEntry(CheckInEntry entry) async {
    final prefs = await SharedPreferences.getInstance();
    final current = await getEntries();
    final updated = [entry, ...current];
    await prefs.setStringList(
      _storageKey,
      updated.map((e) => jsonEncode(e.toJson())).toList(),
    );
  }

  @override
  Future<void> deleteEntry(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final current = await getEntries();
    final updated = current.where((e) => e.id != id).toList();
    await prefs.setStringList(
      _storageKey,
      updated.map((e) => jsonEncode(e.toJson())).toList(),
    );
  }

  @override
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}

final checkInRepositoryProvider = Provider<CheckInRepository>((ref) {
  return SharedPrefsCheckInRepository();
});
