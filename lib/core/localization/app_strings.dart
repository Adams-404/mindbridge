import '../providers.dart';

class AppStrings {
  const AppStrings._();

  static const String translationReviewStatus =
      'Translation review in progress · Fassarar na kan bita';

  static const String reviewDisclaimerEn =
      'Translations are prepared with care and marked as Community & Clinical Review in Progress. No machine translation is presented as fully approved.';

  static const String reviewDisclaimerHa =
      'An shirya fassarar ne tare da kulawa kuma tana karkashin bitar al\'umma da masana lafiya. Ba a amince da fassarar na\'ura a matsayin cikakkiya ba tukuna.';

  // Navigation
  static String navHome(AppLanguage lang) =>
      lang == AppLanguage.hausa ? 'Gida' : 'Home';

  static String navLearn(AppLanguage lang) =>
      lang == AppLanguage.hausa ? 'Koyi' : 'Learn';

  static String navCheckIn(AppLanguage lang) =>
      lang == AppLanguage.hausa ? 'Dubawa' : 'Check-in';

  static String navSupport(AppLanguage lang) =>
      lang == AppLanguage.hausa ? 'Tallafi' : 'Support';

  // Home Screen
  static String homeSpaceToBegin(AppLanguage lang) =>
      lang == AppLanguage.hausa ? 'WURIN FARAWA' : 'A SPACE TO BEGIN';

  static String homeGreeting(AppLanguage lang) =>
      lang == AppLanguage.hausa ? 'Muna maraba da\nzuwanka.' : 'Good to have\nyou here.';

  static String homeSubtitle(AppLanguage lang) => lang == AppLanguage.hausa
      ? 'Kuna iya daukar lokacinku. Bincika abin da kuke ganin yana da amfani, ku bar sauran don wata rana.'
      : 'You can take your time. Explore what feels useful, and leave the rest for another day.';

  static String homeMomentForYou(AppLanguage lang) =>
      lang == AppLanguage.hausa ? 'LOKACI DON KAI' : 'A MOMENT FOR YOU';

  static String homeHowAreThings(AppLanguage lang) =>
      lang == AppLanguage.hausa ? 'Yaya kake ji\na yau?' : 'How are things\nfeeling today?';

  static String homeNoRightAnswer(AppLanguage lang) => lang == AppLanguage.hausa
      ? 'Babu amsa daidai. Sai dai wadda kake ji.'
      : 'No right answer. Just yours.';

  static String homeCheckInButton(AppLanguage lang) => lang == AppLanguage.hausa
      ? 'Duba yadda kake ji, idan kana so'
      : 'Check in, if you like';

  static String homePlaceToBegin(AppLanguage lang) =>
      lang == AppLanguage.hausa ? 'Wurin farawa' : 'A place to begin';

  static String homeActionLearnTitle(AppLanguage lang) =>
      lang == AppLanguage.hausa ? 'Koyi kuma ka fahimta' : 'Learn and understand';

  static String homeActionLearnSubtitle(AppLanguage lang) => lang == AppLanguage.hausa
      ? 'Bincika bayanan lafiyar kwakwalwa'
      : 'Explore mental health information';

  static String homeActionBreathingTitle(AppLanguage lang) =>
      lang == AppLanguage.hausa ? 'Huta ka sha iska' : 'Take a breathing pause';

  static String homeActionBreathingSubtitle(AppLanguage lang) => lang == AppLanguage.hausa
      ? 'Dan lokaci kadan a kan yadda kake so'
      : 'A few moments at your own pace';

  static String homeActionSupportTitle(AppLanguage lang) =>
      lang == AppLanguage.hausa ? 'Nemi tallafi' : 'Find support';

  static String homeActionSupportSubtitle(AppLanguage lang) => lang == AppLanguage.hausa
      ? 'Fahimci zabin samun kulawar kwararru'
      : 'Understand your options for professional care';

  static String homeActionRemindersTitle(AppLanguage lang) =>
      lang == AppLanguage.hausa ? 'Rike tunatarwa a gaba' : 'Keep a follow-up in sight';

  static String homeActionRemindersSubtitle(AppLanguage lang) => lang == AppLanguage.hausa
      ? 'Yi tunatarwa don kanka'
      : 'Make a personal reminder';

  static String homeActionAssistantTitle(AppLanguage lang) => lang == AppLanguage.hausa
      ? 'Mataimakin bayanan MindBridge'
      : 'MindBridge information assistant';

  static String homeActionAssistantSubtitle(AppLanguage lang) => lang == AppLanguage.hausa
      ? 'Shiri ne da za a gabatar, ba ya aiki yanzu'
      : 'A planned feature, not active yet';

  // Safety Note
  static String safetyNoteText(AppLanguage lang) => lang == AppLanguage.hausa
      ? 'MindBridge yana raba bayanan gama-gari ne kawai. Ba ya bayar da ganewar asali ko maye gurbin kulawar kwararren likita.'
      : 'MindBridge shares general information. It does not diagnose conditions or replace care from a qualified health professional.';

  // Settings
  static String settingsTitle(AppLanguage lang) =>
      lang == AppLanguage.hausa ? 'Saituna.' : 'Settings.';

  static String settingsEyebrow(AppLanguage lang) =>
      lang == AppLanguage.hausa ? 'SAITA YADDA KAKE SO' : 'MAKE IT YOURS';

  static String settingsLanguageTitle(AppLanguage lang) =>
      lang == AppLanguage.hausa ? 'Harshe' : 'Language';

  static String settingsLanguageSubtitle(AppLanguage lang) => lang == AppLanguage.hausa
      ? 'Zabi harshen da ya fi dacewa da kai. Zabin da ka yi zai ci gaba da aiki.'
      : 'Choose a language. Your selection is remembered on this device.';

  static String settingsPrivacyTitle(AppLanguage lang) =>
      lang == AppLanguage.hausa ? 'Sirri da Tsaro' : 'Privacy and safety';

  // Support
  static String supportTitle(AppLanguage lang) =>
      lang == AppLanguage.hausa ? 'Neman tallafin\nda ya dace.' : 'Finding the\nright support.';

  static String supportEyebrow(AppLanguage lang) => lang == AppLanguage.hausa
      ? 'BA SAI KA YI SHI KAI KADAI BA'
      : 'YOU DO NOT HAVE TO FIGURE IT OUT ALONE';

  static String supportDirectoryTitle(AppLanguage lang) => lang == AppLanguage.hausa
      ? 'Jerin kwararru da aka tantance'
      : 'Verified support directory';

  static String supportDirectoryNotice(AppLanguage lang) => lang == AppLanguage.hausa
      ? 'Muna kan tsara tsarin tantance kwararru da cibiyoyi kafin sanya su a nan. Babu jerin sunayen da aka riga aka tantance a wannan samfurin tukuna.'
      : 'We are building a process to verify professionals and services before listing them. There are no verified provider listings available in this prototype yet.';
}
