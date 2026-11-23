import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SupportProviderEntry {
  const SupportProviderEntry({
    required this.name,
    required this.qualification,
    required this.isVerified,
    required this.lastChecked,
    required this.services,
  });

  final String name;
  final String qualification;
  final bool isVerified;
  final DateTime lastChecked;
  final List<String> services;
}

class SupportDirectoryMetadata {
  const SupportDirectoryMetadata({
    required this.isAvailable,
    required this.statusMessage,
    required this.verificationGuidelines,
  });

  final bool isAvailable;
  final String statusMessage;
  final String verificationGuidelines;
}

class CrisisHelplineEntry {
  const CrisisHelplineEntry({
    required this.region,
    required this.title,
    required this.number,
    required this.availability,
    required this.description,
    this.isEmergency = false,
  });

  final String region;
  final String title;
  final String number;
  final String availability;
  final String description;
  final bool isEmergency;
}

const verifiedCrisisHelplines = <CrisisHelplineEntry>[
  CrisisHelplineEntry(
    region: 'North America (US & Canada)',
    title: '988 Suicide & Crisis Lifeline',
    number: '988',
    availability: '24/7 · Free & Confidential',
    description: 'Immediate counseling and crisis support via voice call or SMS text.',
    isEmergency: true,
  ),
  CrisisHelplineEntry(
    region: 'United Kingdom',
    title: 'NHS 111 Mental Health Triage',
    number: '111',
    availability: '24/7 · Freephone',
    description: 'Direct clinical assessment by trained NHS mental health practitioners.',
    isEmergency: true,
  ),
  CrisisHelplineEntry(
    region: 'European Union',
    title: 'European Unified Emergency Services',
    number: '112',
    availability: '24/7 · Toll-free across EU',
    description: 'Immediate connection to European emergency medical and psychiatric response.',
    isEmergency: true,
  ),
  CrisisHelplineEntry(
    region: 'Nigeria & West Africa',
    title: 'National Emergency Response',
    number: '112',
    availability: '24/7 · Toll-free',
    description: 'Nigeria national toll-free emergency call center.',
    isEmergency: true,
  ),
  CrisisHelplineEntry(
    region: 'Nigeria & West Africa',
    title: 'Mentally Aware Nigeria Initiative (MANI)',
    number: '+234 809 111 6264',
    availability: '24/7 · Confidential',
    description: 'Confidential crisis intervention and youth-centered mental health counseling.',
  ),
];

class AppointmentPrepItem {
  const AppointmentPrepItem({
    required this.id,
    required this.category,
    required this.question,
    required this.rationale,
  });

  final String id;
  final String category;
  final String question;
  final String rationale;
}

const appointmentPrepQuestions = <AppointmentPrepItem>[
  AppointmentPrepItem(
    id: 'prep-credentials',
    category: 'Qualifications',
    question: 'What licensing and specialized clinical experience do you hold?',
    rationale: 'Confirms that the provider is certified by an accredited licensing board for your specific concerns.',
  ),
  AppointmentPrepItem(
    id: 'prep-modalities',
    category: 'Treatment Approach',
    question: 'What therapeutic approaches (e.g. CBT, ACT, Interpersonal) do you practice?',
    rationale: 'Helps determine if their evidence-based methodology aligns with your recovery goals.',
  ),
  AppointmentPrepItem(
    id: 'prep-confidentiality',
    category: 'Privacy & Rights',
    question: 'How is my private health information safeguarded and what are the legal limits?',
    rationale: 'Ensures absolute clarity regarding ethical confidentiality and mandatory disclosure exceptions.',
  ),
  AppointmentPrepItem(
    id: 'prep-costs',
    category: 'Financials',
    question: 'What are your session fees, insurance coverage, or sliding scale options?',
    rationale: 'Prevents unexpected medical bills and ensures sustainable ongoing care.',
  ),
  AppointmentPrepItem(
    id: 'prep-evaluation',
    category: 'Collaboration',
    question: 'How will we monitor progress and evaluate whether therapy is working for me?',
    rationale: 'Promotes patient autonomy and collaborative review throughout the therapeutic journey.',
  ),
];

abstract interface class SupportRepository {
  Future<SupportDirectoryMetadata> getDirectoryMetadata();
  Future<List<SupportProviderEntry>> getProviders();
  List<CrisisHelplineEntry> getCrisisHelplines();
  List<AppointmentPrepItem> getAppointmentPrepItems();
}

class BundledSupportRepository implements SupportRepository {
  @override
  Future<SupportDirectoryMetadata> getDirectoryMetadata() async {
    return const SupportDirectoryMetadata(
      isAvailable: false,
      statusMessage:
          'We are building a process to verify professionals and services before listing them. Direct provider directory integrations will appear here as they are accredited.',
      verificationGuidelines:
          'Providers will only be listed after primary-source license verification, clinical review, and confirmed contact channels.',
    );
  }

  @override
  Future<List<SupportProviderEntry>> getProviders() async {
    // Empty by default: no fabricated or unverified providers
    return const [];
  }

  @override
  List<CrisisHelplineEntry> getCrisisHelplines() => verifiedCrisisHelplines;

  @override
  List<AppointmentPrepItem> getAppointmentPrepItems() => appointmentPrepQuestions;
}

final supportRepositoryProvider = Provider<SupportRepository>((ref) {
  return BundledSupportRepository();
});

final supportDirectoryMetadataProvider = FutureProvider<SupportDirectoryMetadata>((ref) {
  return ref.watch(supportRepositoryProvider).getDirectoryMetadata();
});

class SupportChecklistNotifier extends StateNotifier<Set<String>> {
  SupportChecklistNotifier() : super({}) {
    load();
  }

  static const _storageKey = 'mindbridge_support_checklist';

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_storageKey) ?? [];
    state = list.toSet();
  }

  Future<void> toggle(String id) async {
    final updated = Set<String>.from(state);
    if (updated.contains(id)) {
      updated.remove(id);
    } else {
      updated.add(id);
    }
    state = updated;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_storageKey, updated.toList());
  }

  Future<void> clearAll() async {
    state = {};
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}

final supportChecklistProvider =
    StateNotifierProvider<SupportChecklistNotifier, Set<String>>((ref) {
  return SupportChecklistNotifier();
});
