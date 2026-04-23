import 'app_language.dart';

class HomeCopy {
  const HomeCopy({
    required this.welcomeTitle,
    required this.subtitle,
    required this.selectLanguageTitle,
    required this.selectLanguageHint,
    required this.generateCase,
    required this.uploadHint,
    required this.supportedFormats,
  });

  final String welcomeTitle;
  final String subtitle;
  final String selectLanguageTitle;
  final String selectLanguageHint;
  final String generateCase;
  final String uploadHint;
  final String supportedFormats;

  static HomeCopy fromLanguage(AppLanguage language) {
    switch (language) {
      case AppLanguage.english:
        return const HomeCopy(
          welcomeTitle: 'Welcome to the case generator',
          subtitle:
              'Upload your case document and\nselect your preferred language',
          selectLanguageTitle: 'Select language',
          selectLanguageHint:
              'Choose the language for your generated\ncase content',
          generateCase: 'Generate case',
          uploadHint: 'Click to browse, or drag and drop your file here',
          supportedFormats: 'Supported formats: Images, PDF, DOCX, TXT',
        );
      case AppLanguage.dutch:
        return const HomeCopy(
          welcomeTitle: 'Welkom bij de casusgenerator',
          subtitle: 'Upload je casusdocument en\nselecteer je voorkeurstaal',
          selectLanguageTitle: 'Selecteer taal',
          selectLanguageHint: 'Kies de taal voor je gegenereerde\ncasusinhoud',
          generateCase: 'Genereer casus',
          uploadHint: 'Klik om te bladeren, of sleep je bestand hierheen',
          supportedFormats:
              'Ondersteunde formaten: Afbeeldingen, PDF, DOCX, TXT',
        );
    }
  }
}
