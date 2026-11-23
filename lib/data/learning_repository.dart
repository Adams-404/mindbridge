import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'learning_content.dart';

abstract interface class LearningRepository {
  List<LearningArticle> getArticles();
}

class BundledLearningRepository implements LearningRepository {
  @override
  List<LearningArticle> getArticles() => learningArticles;
}

final learningRepositoryProvider = Provider<LearningRepository>(
  (ref) => BundledLearningRepository(),
);

abstract interface class CourseStorageRepository {
  Future<Set<String>> getDownloadedCourseIds();
  Future<void> toggleDownload(String courseId);
  Future<Map<String, List<QuizAttemptRecord>>> getAllAttempts();
  Future<void> saveAttempt(QuizAttemptRecord attempt);
  Future<Map<String, CourseCertificate>> getAllCertificates();
  Future<void> saveCertificate(CourseCertificate certificate);
}

class SharedPrefsCourseStorageRepository implements CourseStorageRepository {
  static const _downloadedKey = 'mindbridge_downloaded_courses';
  static const _attemptsKey = 'mindbridge_quiz_attempts';
  static const _certificatesKey = 'mindbridge_certificates';

  @override
  Future<Set<String>> getDownloadedCourseIds() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_downloadedKey) ?? [];
    return list.toSet();
  }

  @override
  Future<void> toggleDownload(String courseId) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_downloadedKey) ?? [];
    final set = list.toSet();
    if (set.contains(courseId)) {
      set.remove(courseId);
    } else {
      set.add(courseId);
    }
    await prefs.setStringList(_downloadedKey, set.toList());
  }

  @override
  Future<Map<String, List<QuizAttemptRecord>>> getAllAttempts() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_attemptsKey);
    if (raw == null || raw.isEmpty) return {};
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      final result = <String, List<QuizAttemptRecord>>{};
      decoded.forEach((key, val) {
        if (val is List) {
          result[key] = val
              .map((item) => QuizAttemptRecord.fromJson(item as Map<String, dynamic>))
              .toList();
        }
      });
      return result;
    } catch (_) {
      return {};
    }
  }

  @override
  Future<void> saveAttempt(QuizAttemptRecord attempt) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = await getAllAttempts();
    final list = existing[attempt.courseId] ?? [];
    list.add(attempt);
    existing[attempt.courseId] = list;

    final encoded = jsonEncode(
      existing.map((key, val) => MapEntry(key, val.map((e) => e.toJson()).toList())),
    );
    await prefs.setString(_attemptsKey, encoded);
  }

  @override
  Future<Map<String, CourseCertificate>> getAllCertificates() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_certificatesKey);
    if (raw == null || raw.isEmpty) return {};
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return decoded.map(
        (key, val) => MapEntry(
          key,
          CourseCertificate.fromJson(val as Map<String, dynamic>),
        ),
      );
    } catch (_) {
      return {};
    }
  }

  @override
  Future<void> saveCertificate(CourseCertificate certificate) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = await getAllCertificates();
    existing[certificate.courseId] = certificate;
    final encoded = jsonEncode(
      existing.map((key, val) => MapEntry(key, val.toJson())),
    );
    await prefs.setString(_certificatesKey, encoded);
  }
}

final courseStorageRepositoryProvider = Provider<CourseStorageRepository>((ref) {
  return SharedPrefsCourseStorageRepository();
});

class DownloadedCoursesNotifier extends StateNotifier<Set<String>> {
  DownloadedCoursesNotifier(this._repository) : super({}) {
    load();
  }

  final CourseStorageRepository _repository;

  Future<void> load() async {
    final ids = await _repository.getDownloadedCourseIds();
    state = ids;
  }

  Future<void> toggle(String courseId) async {
    await _repository.toggleDownload(courseId);
    await load();
  }
}

final downloadedCoursesProvider =
    StateNotifierProvider<DownloadedCoursesNotifier, Set<String>>((ref) {
  return DownloadedCoursesNotifier(ref.watch(courseStorageRepositoryProvider));
});

class CourseAttemptsNotifier
    extends StateNotifier<Map<String, List<QuizAttemptRecord>>> {
  CourseAttemptsNotifier(this._repository) : super({}) {
    load();
  }

  final CourseStorageRepository _repository;

  Future<void> load() async {
    final attempts = await _repository.getAllAttempts();
    state = attempts;
  }

  Future<void> recordAttempt(QuizAttemptRecord attempt) async {
    await _repository.saveAttempt(attempt);
    await load();
  }
}

final courseAttemptsProvider =
    StateNotifierProvider<CourseAttemptsNotifier, Map<String, List<QuizAttemptRecord>>>(
  (ref) => CourseAttemptsNotifier(ref.watch(courseStorageRepositoryProvider)),
);

class CourseCertificatesNotifier
    extends StateNotifier<Map<String, CourseCertificate>> {
  CourseCertificatesNotifier(this._repository) : super({}) {
    load();
  }

  final CourseStorageRepository _repository;

  Future<void> load() async {
    final certs = await _repository.getAllCertificates();
    state = certs;
  }

  Future<void> issueCertificate(CourseCertificate certificate) async {
    await _repository.saveCertificate(certificate);
    await load();
  }
}

final courseCertificatesProvider =
    StateNotifierProvider<CourseCertificatesNotifier, Map<String, CourseCertificate>>(
  (ref) => CourseCertificatesNotifier(ref.watch(courseStorageRepositoryProvider)),
);
