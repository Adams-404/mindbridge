import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mindbridge/data/learning_content.dart';
import 'package:mindbridge/data/learning_repository.dart';
import 'package:mindbridge/features/learn/learn_screen.dart';

class InMemoryCourseStorageRepository implements CourseStorageRepository {
  final Set<String> _downloaded = {};
  final Map<String, List<QuizAttemptRecord>> _attempts = {};
  final Map<String, CourseCertificate> _certificates = {};

  @override
  Future<Set<String>> getDownloadedCourseIds() async => Set.from(_downloaded);

  @override
  Future<void> toggleDownload(String courseId) async {
    if (_downloaded.contains(courseId)) {
      _downloaded.remove(courseId);
    } else {
      _downloaded.add(courseId);
    }
  }

  @override
  Future<Map<String, List<QuizAttemptRecord>>> getAllAttempts() async => Map.from(_attempts);

  @override
  Future<void> saveAttempt(QuizAttemptRecord attempt) async {
    final list = _attempts[attempt.courseId] ?? [];
    list.add(attempt);
    _attempts[attempt.courseId] = list;
  }

  @override
  Future<Map<String, CourseCertificate>> getAllCertificates() async => Map.from(_certificates);

  @override
  Future<void> saveCertificate(CourseCertificate certificate) async {
    _certificates[certificate.courseId] = certificate;
  }
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Widget buildTestableLearnScreen({CourseStorageRepository? storageRepo}) {
    final repo = storageRepo ?? InMemoryCourseStorageRepository();
    return ProviderScope(
      overrides: [
        courseStorageRepositoryProvider.overrideWithValue(repo),
      ],
      child: const MaterialApp(
        home: Scaffold(body: LearnScreen()),
      ),
    );
  }

  testWidgets('LearnScreen renders courses, lessons duration, and search filtering', (tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildTestableLearnScreen());
    await tester.pumpAndSettle();

    expect(find.text('Understanding depression'), findsOneWidget);
    expect(find.text('Understanding anxiety'), findsOneWidget);
    expect(find.text('⏱ 10 min'), findsWidgets);
    expect(find.byIcon(Icons.school_outlined), findsWidgets);

    // Search for anxiety
    await tester.enterText(find.byType(TextField), 'anxiety');
    await tester.pumpAndSettle();

    expect(find.text('Understanding anxiety'), findsOneWidget);
    expect(find.text('Understanding depression'), findsNothing);
    expect(find.text('1 article'), findsOneWidget);
  });

  testWidgets('Course detail sheet displays structured modular lessons and clinical takeaways', (tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildTestableLearnScreen());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Understanding depression'));
    await tester.pumpAndSettle();

    final sheetScrollable = find.descendant(
      of: find.byKey(const Key('course_detail_list_view')),
      matching: find.byType(Scrollable),
    );

    await tester.scrollUntilVisible(
      find.text('COURSE LESSONS'),
      100,
      scrollable: sheetScrollable,
    );
    await tester.pumpAndSettle();

    expect(find.text('COURSE LESSONS'), findsOneWidget);
    expect(find.text('Lesson 1'), findsOneWidget);
    expect(find.text('Key Clinical Takeaways'), findsOneWidget);
    expect(find.text('Diagnostic criteria require persistent symptoms for at least two weeks'), findsOneWidget);

    // Switch to Lesson 2
    await tester.tap(find.text('Lesson 2'));
    await tester.pumpAndSettle();

    expect(find.text('The Cognitive Triad & Inactivity Cycles'), findsOneWidget);
    expect(find.text('Beck\'s cognitive triad distorts perception across self, world, and future'), findsOneWidget);
  });

  testWidgets('Offline course caching: user can download course and filter by offline', (tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final storage = InMemoryCourseStorageRepository();
    await tester.pumpWidget(buildTestableLearnScreen(storageRepo: storage));
    await tester.pumpAndSettle();

    // Tap download icon on first course
    final downloadButtons = find.byTooltip('Download course offline');
    expect(downloadButtons, findsWidgets);
    await tester.tap(downloadButtons.first);
    await tester.pumpAndSettle();

    // Verify downloaded chip shows (1)
    expect(find.text('💾 Offline (1)'), findsOneWidget);

    // Filter by offline courses
    await tester.tap(find.text('💾 Offline (1)'));
    await tester.pumpAndSettle();

    expect(find.text('1 article'), findsOneWidget);
    expect(find.text('Understanding depression'), findsOneWidget);
    expect(find.text('Understanding anxiety'), findsNothing);
  });

  testWidgets('Quiz flow: user passes with 100% and receives verifiable Certificate of Completion', (tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final storage = InMemoryCourseStorageRepository();
    await tester.pumpWidget(buildTestableLearnScreen(storageRepo: storage));
    await tester.pumpAndSettle();

    // Open depression course
    await tester.tap(find.text('Understanding depression'));
    await tester.pumpAndSettle();

    final verticalScrollable = find.descendant(
      of: find.byKey(const Key('course_detail_list_view')),
      matching: find.byWidgetPredicate((w) => w is Scrollable && w.axisDirection == AxisDirection.down),
    );

    // Tap Take Quiz
    final takeQuizButton = find.text('Take Quiz for Certificate');
    await tester.scrollUntilVisible(
      takeQuizButton,
      150,
      scrollable: verticalScrollable,
    );
    await tester.drag(verticalScrollable, const Offset(0, -300));
    await tester.pumpAndSettle();
    expect(takeQuizButton, findsOneWidget);
    await tester.tap(takeQuizButton);
    await tester.pumpAndSettle();

    expect(find.text('QUESTION 1 OF 3'), findsOneWidget);

    // Q1 correct: 'At least 2 weeks'
    await tester.tap(find.text('At least 2 weeks'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Next Question'));
    await tester.pumpAndSettle();

    // Q2 correct: 'Scheduling manageable activities to break the withdrawal loop before mood returns'
    await tester.tap(find.text('Scheduling manageable activities to break the withdrawal loop before mood returns'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Next Question'));
    await tester.pumpAndSettle();

    // Q3 correct: 'When persistent distress interferes with daily functioning, work, or relationships'
    await tester.tap(find.text('When persistent distress interferes with daily functioning, work, or relationships'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Submit Quiz'));
    await tester.pumpAndSettle();

    // Check pass result
    expect(find.text('Course Passed & Certified!'), findsOneWidget);
    expect(find.text('Your Score: 100% (3/3 correct)'), findsOneWidget);

    // View Certificate
    await tester.tap(find.text('View Your Certificate'));
    await tester.pumpAndSettle();

    expect(find.text('MINDBRIDGE ACADEMY'), findsOneWidget);
    expect(find.text('CERTIFICATE OF COMPLETION'), findsOneWidget);
    expect(find.text('Understanding depression'), findsWidgets);
    expect(find.text('100%'), findsOneWidget);
  });

  testWidgets('Quiz flow: user scores < 70% and can see remaining attempts', (tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final storage = InMemoryCourseStorageRepository();
    await tester.pumpWidget(buildTestableLearnScreen(storageRepo: storage));
    await tester.pumpAndSettle();

    // Open depression course
    await tester.tap(find.text('Understanding depression'));
    await tester.pumpAndSettle();

    final verticalScrollable = find.descendant(
      of: find.byKey(const Key('course_detail_list_view')),
      matching: find.byWidgetPredicate((w) => w is Scrollable && w.axisDirection == AxisDirection.down),
    );

    // Tap Take Quiz
    final takeQuizButton = find.text('Take Quiz for Certificate');
    await tester.scrollUntilVisible(
      takeQuizButton,
      150,
      scrollable: verticalScrollable,
    );
    await tester.drag(verticalScrollable, const Offset(0, -300));
    await tester.pumpAndSettle();
    expect(takeQuizButton, findsOneWidget);
    await tester.tap(takeQuizButton);
    await tester.pumpAndSettle();

    // Choose wrong answers
    await tester.tap(find.text('At least 2 days')); // incorrect
    await tester.pumpAndSettle();
    await tester.tap(find.text('Next Question'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Staying in bed until all sadness subsides')); // incorrect
    await tester.pumpAndSettle();
    await tester.tap(find.text('Next Question'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Never, because reading articles is always sufficient')); // incorrect
    await tester.pumpAndSettle();
    await tester.tap(find.text('Submit Quiz'));
    await tester.pumpAndSettle();

    // Check fail result
    expect(find.text('Quiz Needs Review'), findsOneWidget);
    expect(find.text('Your Score: 0% (0/3 correct)'), findsOneWidget);

    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();

    // Verification of remaining attempts
    expect(find.text('Past attempts: 0% (Attempts left: 2)'), findsOneWidget);
  });
}
