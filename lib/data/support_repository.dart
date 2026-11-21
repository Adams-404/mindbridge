import 'package:flutter_riverpod/flutter_riverpod.dart';

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

abstract interface class SupportRepository {
  Future<SupportDirectoryMetadata> getDirectoryMetadata();
  Future<List<SupportProviderEntry>> getProviders();
}

class BundledSupportRepository implements SupportRepository {
  @override
  Future<SupportDirectoryMetadata> getDirectoryMetadata() async {
    return const SupportDirectoryMetadata(
      isAvailable: false,
      statusMessage:
          'We are building a process to verify professionals and services before listing them. There are no verified provider listings available in this prototype yet.',
      verificationGuidelines:
          'Providers will only be listed after primary-source license verification, clinical review, and confirmed contact channels.',
    );
  }

  @override
  Future<List<SupportProviderEntry>> getProviders() async {
    // Empty by default: no fabricated or unverified providers
    return const [];
  }
}

final supportRepositoryProvider = Provider<SupportRepository>((ref) {
  return BundledSupportRepository();
});

final supportDirectoryMetadataProvider = FutureProvider<SupportDirectoryMetadata>((ref) {
  return ref.watch(supportRepositoryProvider).getDirectoryMetadata();
});
