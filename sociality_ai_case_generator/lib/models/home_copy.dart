import 'app_language.dart';

class HomeCopy {
  const HomeCopy({
    // ── Home page ─────────────────────────────────────────────────────────────
    required this.welcomeTitle,
    required this.subtitle,
    required this.promptTitle,
    required this.promptHint,
    required this.uploadSectionTitle,
    required this.uploadHint,
    required this.supportedFormats,
    required this.evidenceSelectedLabel,
    required this.evidenceTapToAdd,
    required this.evidenceClearAll,
    required this.photosPickerLabel,
    required this.photosPickerSubtitle,
    required this.filesPickerLabel,
    required this.filesPickerSubtitle,
    required this.difficultyTitle,
    required this.difficultyHint,
    required this.difficultyEasy,
    required this.difficultyMedium,
    required this.difficultyHard,
    required this.generateCase,
    required this.startOver,
    required this.startOverContent,
    required this.startOverConfirm,
    required this.startOverCancel,
    required this.optional,
    // ── Loading screen ────────────────────────────────────────────────────────
    required this.loadingTitle,
    required this.loadingErrorPrefix,
    required this.loadingNoStepsError,
    required this.loadingFallbackTitle,
    required this.loadingFallbackSubtitle,
    required this.generatingLabel,
    required this.generatingStage1,
    required this.generatingStage2,
    required this.generatingStage3,
    required this.generatingStage4,
    required this.generationFailed,
    required this.retryGeneration,
    required this.useSampleCase,
    // ── Case simulation page ──────────────────────────────────────────────────
    required this.noStepsGenerated,
    required this.startCaseSimulation,
    required this.downloadCase,
    required this.regenerateStep,
    required this.editManually,
    required this.stepLabel,
    required this.choicesLabel,
    required this.tapToSeeChoices,
    required this.tapToFlipBack,
    required this.caseReviewTitle,
    required this.editScenarioLabel,
    required this.saveChanges,
    required this.cancelButton,
    // ── Download success page ─────────────────────────────────────────────────
    required this.downloadSuccessTitle,
    required this.downloadSuccessBody,
    required this.tryCaseTitle,
    required this.tryCaseBody,
    required this.generateAnotherCase,
    // ── How it works overlay ──────────────────────────────────────────────────
    required this.howItWorksTitle,
    required this.howItWorksSubtitle,
    required this.howItWorksStep1Title,
    required this.howItWorksStep1Description,
    required this.howItWorksStep2Title,
    required this.howItWorksStep2Description,
    required this.howItWorksStep3Title,
    required this.howItWorksStep3Description,
    required this.gotIt,
  });

  // ── Home page ───────────────────────────────────────────────────────────────
  final String welcomeTitle;
  final String subtitle;
  final String promptTitle;
  final String promptHint;
  final String uploadSectionTitle;
  final String uploadHint;
  final String supportedFormats;
  final String evidenceSelectedLabel;
  final String evidenceTapToAdd;
  final String evidenceClearAll;
  final String photosPickerLabel;
  final String photosPickerSubtitle;
  final String filesPickerLabel;
  final String filesPickerSubtitle;
  final String difficultyTitle;
  final String difficultyHint;
  final String difficultyEasy;
  final String difficultyMedium;
  final String difficultyHard;
  final String generateCase;
  final String startOver;
  final String startOverContent;
  final String startOverConfirm;
  final String startOverCancel;
  final String optional;
  // ── Loading screen ──────────────────────────────────────────────────────────
  final String loadingTitle;
  final String loadingErrorPrefix;
  final String loadingNoStepsError;
  final String loadingFallbackTitle;
  final String loadingFallbackSubtitle;
  final String generatingLabel;
  final String generatingStage1;
  final String generatingStage2;
  final String generatingStage3;
  final String generatingStage4;
  final String generationFailed;
  final String retryGeneration;
  final String useSampleCase;
  // ── Case simulation page ────────────────────────────────────────────────────
  final String noStepsGenerated;
  final String startCaseSimulation;
  final String downloadCase;
  final String regenerateStep;
  final String editManually;
  final String stepLabel;
  final String choicesLabel;
  final String tapToSeeChoices;
  final String tapToFlipBack;
  final String caseReviewTitle;
  final String editScenarioLabel;
  final String saveChanges;
  final String cancelButton;
  // ── Download success page ───────────────────────────────────────────────────
  final String downloadSuccessTitle;
  final String downloadSuccessBody;
  final String tryCaseTitle;
  final String tryCaseBody;
  final String generateAnotherCase;
  // ── How it works overlay ────────────────────────────────────────────────────
  final String howItWorksTitle;
  final String howItWorksSubtitle;
  final String howItWorksStep1Title;
  final String howItWorksStep1Description;
  final String howItWorksStep2Title;
  final String howItWorksStep2Description;
  final String howItWorksStep3Title;
  final String howItWorksStep3Description;
  final String gotIt;

  static HomeCopy fromLanguage(AppLanguage language) {
    switch (language) {
      case AppLanguage.english:
        return const HomeCopy(
          welcomeTitle: 'Welcome to the case generator',
          subtitle: 'Describe your scenario and choose your settings',
          promptTitle: 'Case prompt',
          promptHint: 'Describe the case scenario you want to generate…',
          uploadSectionTitle: 'Supporting materials',
          uploadHint: 'Click to browse, or drag and drop your file here',
          supportedFormats: 'Supported formats: Images, PDF, DOCX, TXT',
          evidenceSelectedLabel: 'Selected files',
          evidenceTapToAdd: 'Tap to add more files or photos',
          evidenceClearAll: 'Clear all',
          photosPickerLabel: 'Photos',
          photosPickerSubtitle: 'Choose from your photo library',
          filesPickerLabel: 'Files',
          filesPickerSubtitle: 'Choose from the Files app',
          difficultyTitle: 'Difficulty level',
          difficultyHint: 'Choose how complex the generated case should be',
          difficultyEasy: 'Easy',
          difficultyMedium: 'Medium',
          difficultyHard: 'Hard',
          generateCase: 'Generate case',
          startOver: 'Start over',
          startOverContent:
              'This will clear the prompt, all files, and reset the difficulty.',
          startOverConfirm: 'Yes, clear',
          startOverCancel: 'Keep',
          optional: 'optional',
          loadingTitle: 'Loading your case',
          loadingErrorPrefix: 'Could not generate case',
          loadingNoStepsError: 'The case was generated but contains no content.',
          loadingFallbackTitle: 'Loading sample case',
          loadingFallbackSubtitle: 'Loading sample case…',
          generatingLabel: 'Generating…',
          generatingStage1: 'Structuring your case',
          generatingStage2: 'Writing step options',
          generatingStage3: 'Adding consequences',
          generatingStage4: 'Finalising',
          generationFailed: 'Generation failed',
          retryGeneration: 'Try again',
          useSampleCase: 'Use sample case',
          noStepsGenerated: 'No steps were generated.',
          startCaseSimulation: 'Start case simulation',
          downloadCase: 'Download case',
          regenerateStep: 'Regenerate this step',
          editManually: 'Edit manually',
          stepLabel: 'Step',
          choicesLabel: 'Choices',
          tapToSeeChoices: 'Tap to see choices',
          tapToFlipBack: 'Flip back',
          caseReviewTitle: 'Generated Case',
          editScenarioLabel: 'Scenario',
          saveChanges: 'Save',
          cancelButton: 'Cancel',
          downloadSuccessTitle: 'Download\nsuccessful!',
          downloadSuccessBody:
              'Your case has been downloaded successfully.\nYou can now use it in your educational programs.',
          tryCaseTitle: 'Try your case!',
          tryCaseBody:
              'Test your generated case in an interactive simulation to see how it works in practice.',
          generateAnotherCase: 'Generate another case',
          howItWorksTitle: 'How it works',
          howItWorksSubtitle:
              'Create engaging case-based learning\ncontent in three simple steps',
          howItWorksStep1Title: 'Upload Your Document',
          howItWorksStep1Description:
              'Upload your case study or educational material in PDF, DOCX, or TXT format. Select your preferred language (Dutch or English).',
          howItWorksStep2Title: 'AI Generates Your Case',
          howItWorksStep2Description:
              'Our AI analyzes your document and automatically creates structured, game-based learning content following a proven six-step pedagogical model.',
          howItWorksStep3Title: 'Review & Download',
          howItWorksStep3Description:
              'Review the generated content, make any edits you need, and download your case for immediate use in your educational programs.',
          gotIt: 'Got it!',
        );
      case AppLanguage.dutch:
        return const HomeCopy(
          welcomeTitle: 'Welkom bij de casusgenerator',
          subtitle: 'Beschrijf je scenario en kies je instellingen',
          promptTitle: 'Casusprompt',
          promptHint: 'Beschrijf het casusscenario dat je wilt genereren…',
          uploadSectionTitle: 'Ondersteunende bestanden',
          uploadHint: 'Klik om te bladeren, of sleep je bestand hierheen',
          supportedFormats:
              'Ondersteunde formaten: Afbeeldingen, PDF, DOCX, TXT',
          evidenceSelectedLabel: 'Geselecteerde bestanden',
          evidenceTapToAdd: 'Tik om meer bestanden of foto\'s toe te voegen',
          evidenceClearAll: 'Alles wissen',
          photosPickerLabel: 'Foto\'s',
          photosPickerSubtitle: 'Kies uit je fotobibliotheek',
          filesPickerLabel: 'Bestanden',
          filesPickerSubtitle: 'Kies uit de Bestanden-app',
          difficultyTitle: 'Moeilijkheidsgraad',
          difficultyHint: 'Kies hoe complex de gegenereerde casus moet zijn',
          difficultyEasy: 'Makkelijk',
          difficultyMedium: 'Gemiddeld',
          difficultyHard: 'Moeilijk',
          generateCase: 'Genereer casus',
          startOver: 'Opnieuw beginnen',
          startOverContent:
              'Dit wist de prompt, alle bestanden en stelt de moeilijkheidsgraad opnieuw in.',
          startOverConfirm: 'Ja, wissen',
          startOverCancel: 'Behouden',
          optional: 'optioneel',
          loadingTitle: 'Je casus laden',
          loadingErrorPrefix: 'Kon casus niet genereren',
          loadingNoStepsError: 'De casus is aangemaakt maar bevat geen inhoud.',
          loadingFallbackTitle: 'Voorbeeldcasus laden',
          loadingFallbackSubtitle: 'Voorbeeldcasus laden…',
          generatingLabel: 'Genereren…',
          generatingStage1: 'Je casus structureren',
          generatingStage2: 'Stapopties schrijven',
          generatingStage3: 'Gevolgen toevoegen',
          generatingStage4: 'Afronden',
          generationFailed: 'Generatie mislukt',
          retryGeneration: 'Opnieuw proberen',
          useSampleCase: 'Gebruik voorbeeldcasus',
          noStepsGenerated: 'Er zijn geen stappen gegenereerd.',
          startCaseSimulation: 'Start casussimulatie',
          downloadCase: 'Casus downloaden',
          regenerateStep: 'Stap opnieuw genereren',
          editManually: 'Handmatig bewerken',
          stepLabel: 'Stap',
          choicesLabel: 'Keuzes',
          tapToSeeChoices: 'Tik om keuzes te zien',
          tapToFlipBack: 'Terugdraaien',
          caseReviewTitle: 'Gegenereerde casus',
          editScenarioLabel: 'Scenario',
          saveChanges: 'Opslaan',
          cancelButton: 'Annuleren',
          downloadSuccessTitle: 'Download\ngeslaagd!',
          downloadSuccessBody:
              'Je casus is succesvol gedownload.\nJe kunt het nu gebruiken in je onderwijsprogramma\'s.',
          tryCaseTitle: 'Probeer je casus!',
          tryCaseBody:
              'Test je gegenereerde casus in een interactieve simulatie om te zien hoe het in de praktijk werkt.',
          generateAnotherCase: 'Nog een casus genereren',
          howItWorksTitle: 'Hoe het werkt',
          howItWorksSubtitle:
              'Maak boeiende op cases gebaseerde\nleerinhoud in drie eenvoudige stappen',
          howItWorksStep1Title: 'Upload je document',
          howItWorksStep1Description:
              'Upload je casusstudie of lesmateriaal in PDF-, DOCX- of TXT-formaat. Selecteer je voorkeurstaal (Nederlands of Engels).',
          howItWorksStep2Title: 'AI genereert je casus',
          howItWorksStep2Description:
              'Onze AI analyseert je document en maakt automatisch gestructureerde, spelgebaseerde leerinhoud op basis van een bewezen zesstappenpedagogisch model.',
          howItWorksStep3Title: 'Bekijken en downloaden',
          howItWorksStep3Description:
              'Bekijk de gegenereerde inhoud, maak de gewenste aanpassingen en download je casus voor direct gebruik in je onderwijsprogramma\'s.',
          gotIt: 'Begrepen!',
        );
    }
  }
}
