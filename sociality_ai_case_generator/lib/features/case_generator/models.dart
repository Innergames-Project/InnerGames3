import 'package:flutter/material.dart';

enum AppLanguage { dutch, english }

final ValueNotifier<AppLanguage> caseGeneratorLanguage =
    ValueNotifier(AppLanguage.dutch);

class HomeCopy {
  const HomeCopy({
    required this.welcomeTitle,
    required this.subtitle,
    required this.selectLanguageTitle,
    required this.selectLanguageHint,
    required this.generateCase,
    required this.uploadHint,
    required this.supportedFormats,
    required this.resetCase,
    required this.removeEvidence,
    required this.clearCaseTitle,
    required this.clearCaseMessage,
    required this.clearCaseConfirm,
    required this.clearCaseCancel,
    required this.addEvidenceFirst,
    required this.photosLabel,
    required this.photosSubtitle,
    required this.filesLabel,
    required this.filesSubtitle,
    required this.helpButtonLabel,
  });

  final String welcomeTitle;
  final String subtitle;
  final String selectLanguageTitle;
  final String selectLanguageHint;
  final String generateCase;
  final String uploadHint;
  final String supportedFormats;
  final String resetCase;
  final String removeEvidence;
  final String clearCaseTitle;
  final String clearCaseMessage;
  final String clearCaseConfirm;
  final String clearCaseCancel;
  final String addEvidenceFirst;
  final String photosLabel;
  final String photosSubtitle;
  final String filesLabel;
  final String filesSubtitle;
  final String helpButtonLabel;

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
          resetCase: 'Reset case',
          removeEvidence: 'Remove evidence',
          clearCaseTitle: 'Clear this case?',
          clearCaseMessage:
              'This removes all uploaded evidence and returns the setup to its default state.',
          clearCaseConfirm: 'Clear case',
          clearCaseCancel: 'Keep case',
          addEvidenceFirst: 'Add evidence first, then generate the case.',
          photosLabel: 'Photos',
          photosSubtitle: 'Choose from your photo library',
          filesLabel: 'Files',
          filesSubtitle: 'Choose from the Files app',
          helpButtonLabel: 'How it works',
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
          resetCase: 'Herstel casus',
          removeEvidence: 'Verwijder bewijs',
          clearCaseTitle: 'Casus leegmaken?',
          clearCaseMessage:
              'Hiermee verwijder je alle geüploade bewijsstukken en zet je de instellingen terug naar de standaardwaarde.',
          clearCaseConfirm: 'Casus leegmaken',
          clearCaseCancel: 'Casus behouden',
          addEvidenceFirst: 'Voeg eerst bewijs toe en genereer daarna de casus.',
          photosLabel: 'Foto\'s',
          photosSubtitle: 'Kies uit je fotobibliotheek',
          filesLabel: 'Bestanden',
          filesSubtitle: 'Kies uit de Bestanden-app',
          helpButtonLabel: 'Zo werkt het',
        );
    }
  }
}

class SimulationCopy {
  const SimulationCopy({
    required this.steps,
    required this.startSimulation,
    required this.downloadCase,
    required this.regenerateStep,
    required this.editManually,
    required this.helpButtonLabel,
    required this.stepDetailsBarrierLabel,
  });

  final List<SimulationStepCopy> steps;
  final String startSimulation;
  final String downloadCase;
  final String regenerateStep;
  final String editManually;
  final String helpButtonLabel;
  final String stepDetailsBarrierLabel;

  static SimulationCopy fromLanguage(AppLanguage language) {
    switch (language) {
      case AppLanguage.english:
        return const SimulationCopy(
          steps: [
            SimulationStepCopy(
              index: 1,
              title: 'Introduction & context',
              subtitle: 'Set the stage for the case scenario',
              details: [
                SimulationStepDetailCopy(
                  title: 'Problem analysis',
                  body:
                      'Analyze underlying issues: potential depression diagnosis, social isolation following retirement, financial management difficulties, lack of structured daily routine.',
                ),
                SimulationStepDetailCopy(
                  title: 'Goal setting',
                  body:
                      'Collaborate with Maria to set SMART goals: reconnect with community activities, establish daily routine, address mental health needs, improve financial management.',
                ),
                SimulationStepDetailCopy(
                  title: 'Resource mapping',
                  body:
                      'Identify available resources: community mental health services, local activity groups, financial counseling, volunteer visitor programs.',
                ),
              ],
            ),
            SimulationStepCopy(
              index: 2,
              title: 'Assessment phase',
              subtitle: 'Gather and analyse relevant information',
              details: [
                SimulationStepDetailCopy(
                  title: 'Needs assessment',
                  body:
                      'Collect information about Maria\'s emotional wellbeing, social network, daily functioning, and practical challenges at home.',
                ),
                SimulationStepDetailCopy(
                  title: 'Risk and protective factors',
                  body:
                      'Map potential risks such as worsening isolation and low mood, while identifying strengths like motivation for change and existing support contacts.',
                ),
                SimulationStepDetailCopy(
                  title: 'Baseline documentation',
                  body:
                      'Record initial status indicators to compare progress over time: mood level, participation in activities, financial stress, and routine consistency.',
                ),
              ],
            ),
            SimulationStepCopy(
              index: 3,
              title: 'Analysis & planning',
              subtitle: 'Develop intervention strategies',
              details: [
                SimulationStepDetailCopy(
                  title: 'Intervention strategy',
                  body:
                      'Select a balanced support approach combining psychosocial support, practical coaching, and community engagement pathways.',
                ),
                SimulationStepDetailCopy(
                  title: 'Scenario branching',
                  body:
                      'Prepare alternative plans for low-engagement and high-engagement responses so the support path can adapt quickly.',
                ),
                SimulationStepDetailCopy(
                  title: 'Success indicators',
                  body:
                      'Define measurable outcomes for this step: increased social contact, improved daily structure, and stabilized stress levels.',
                ),
              ],
            ),
            SimulationStepCopy(
              index: 4,
              title: 'Intervention & implementation',
              subtitle: 'Execute the support plan',
              details: [
                SimulationStepDetailCopy(
                  title: 'Action rollout',
                  body:
                      'Start planned interventions in sequence: first routine-building, then social participation tasks, followed by targeted practical supports.',
                ),
                SimulationStepDetailCopy(
                  title: 'Communication plan',
                  body:
                      'Coordinate clear communication between Maria, case worker, and partner services to maintain alignment and accountability.',
                ),
                SimulationStepDetailCopy(
                  title: 'Real-time adjustments',
                  body:
                      'Monitor implementation barriers and make quick adjustments to intensity, pacing, or support channel when needed.',
                ),
              ],
            ),
            SimulationStepCopy(
              index: 5,
              title: 'Monitoring & review',
              subtitle: 'Track progress and adjust as needed',
              details: [
                SimulationStepDetailCopy(
                  title: 'Progress tracking',
                  body:
                      'Review weekly indicators against baseline: emotional wellbeing, activity participation, practical stability, and confidence levels.',
                ),
                SimulationStepDetailCopy(
                  title: 'Reflection moments',
                  body:
                      'Facilitate structured reflection with Maria to identify what is working, what feels difficult, and what should be prioritized next.',
                ),
                SimulationStepDetailCopy(
                  title: 'Outcome review',
                  body:
                      'Assess progress toward SMART goals and decide whether to intensify support, maintain course, or transition to lighter follow-up.',
                ),
              ],
            ),
            SimulationStepCopy(
              index: 6,
              title: 'Closure & transition',
              subtitle: 'Ensure sustainable outcomes',
              details: [
                SimulationStepDetailCopy(
                  title: 'Transition plan',
                  body:
                      'Create a structured step-down plan with clear responsibilities, timelines, and support contacts for the post-case period.',
                ),
                SimulationStepDetailCopy(
                  title: 'Sustainability supports',
                  body:
                      'Secure long-term community anchors, practical check-ins, and self-management tools that help maintain progress.',
                ),
                SimulationStepDetailCopy(
                  title: 'Follow-up schedule',
                  body:
                      'Set follow-up milestones and escalation triggers so emerging concerns can be addressed early and safely.',
                ),
              ],
            ),
          ],
          startSimulation: 'Start case simulation',
          downloadCase: 'Download case',
          regenerateStep: 'Regenerate this step',
          editManually: 'Edit manually',
          helpButtonLabel: 'How it works',
          stepDetailsBarrierLabel: 'Step details',
        );
      case AppLanguage.dutch:
        return const SimulationCopy(
          steps: [
            SimulationStepCopy(
              index: 1,
              title: 'Introductie & context',
              subtitle: 'Zet het scenario van de casus neer',
              details: [
                SimulationStepDetailCopy(
                  title: 'Probleemanalyse',
                  body:
                      'Analyseer de onderliggende kwesties: mogelijke depressie, sociale isolatie na pensionering, financiële problemen en gebrek aan een gestructureerde dagindeling.',
                ),
                SimulationStepDetailCopy(
                  title: 'Doelstelling',
                  body:
                      'Stel samen met Maria SMART-doelen op: opnieuw contact maken met de gemeenschap, een dagroutine opbouwen, mentale gezondheid ondersteunen en financiële structuur verbeteren.',
                ),
                SimulationStepDetailCopy(
                  title: 'Hulpmiddelen in kaart brengen',
                  body:
                      'Breng beschikbare hulpbronnen in kaart: wijkgerichte GGZ, lokale activiteitengroepen, financiële ondersteuning en vrijwilligersbezoek.',
                ),
              ],
            ),
            SimulationStepCopy(
              index: 2,
              title: 'Assesseringsfase',
              subtitle: 'Verzamel en analyseer relevante informatie',
              details: [
                SimulationStepDetailCopy(
                  title: 'Behoefteanalyse',
                  body:
                      'Verzamel informatie over Maria\'s emotionele welzijn, sociaal netwerk, dagelijks functioneren en praktische uitdagingen thuis.',
                ),
                SimulationStepDetailCopy(
                  title: 'Risico- en beschermende factoren',
                  body:
                      'Breng mogelijke risico\'s in kaart, zoals verdere isolatie en somberheid, en benoem tegelijk de sterke punten zoals motivatie voor verandering en bestaande steuncontacten.',
                ),
                SimulationStepDetailCopy(
                  title: 'Nulmeting',
                  body:
                      'Leg de beginsituatie vast om later voortgang te vergelijken: stemming, deelname aan activiteiten, financiële stress en consistentie van de routine.',
                ),
              ],
            ),
            SimulationStepCopy(
              index: 3,
              title: 'Analyse & planning',
              subtitle: 'Ontwikkel interventiestrategieën',
              details: [
                SimulationStepDetailCopy(
                  title: 'Interventiestrategie',
                  body:
                      'Kies een gebalanceerde aanpak met psychosociale steun, praktische coaching en verbinding met de gemeenschap.',
                ),
                SimulationStepDetailCopy(
                  title: 'Scenario-afhankelijke aanpak',
                  body:
                      'Werk alternatieve plannen uit voor lage en hoge betrokkenheid, zodat het ondersteuningspad snel kan bijsturen.',
                ),
                SimulationStepDetailCopy(
                  title: 'Succesindicatoren',
                  body:
                      'Bepaal meetbare uitkomsten voor deze stap: meer sociaal contact, een sterkere dagstructuur en stabielere stressniveaus.',
                ),
              ],
            ),
            SimulationStepCopy(
              index: 4,
              title: 'Interventie & uitvoering',
              subtitle: 'Voer het ondersteuningsplan uit',
              details: [
                SimulationStepDetailCopy(
                  title: 'Uitrol van acties',
                  body:
                      'Start de geplande interventies in volgorde: eerst routine opbouwen, daarna sociale participatie, gevolgd door gerichte praktische ondersteuning.',
                ),
                SimulationStepDetailCopy(
                  title: 'Communicatieplan',
                  body:
                      'Zorg voor heldere communicatie tussen Maria, de casuswerker en partnerdiensten om afstemming en verantwoordelijkheid te behouden.',
                ),
                SimulationStepDetailCopy(
                  title: 'Real-time bijsturing',
                  body:
                      'Volg uitvoeringsdrempels en stuur snel bij in intensiteit, tempo of ondersteuningskanaal wanneer dat nodig is.',
                ),
              ],
            ),
            SimulationStepCopy(
              index: 5,
              title: 'Monitoring & evaluatie',
              subtitle: 'Volg de voortgang en stuur bij waar nodig',
              details: [
                SimulationStepDetailCopy(
                  title: 'Voortgangsbewaking',
                  body:
                      'Vergelijk wekelijkse indicatoren met de nulmeting: emotioneel welzijn, deelname aan activiteiten, praktische stabiliteit en zelfvertrouwen.',
                ),
                SimulationStepDetailCopy(
                  title: 'Reflectiemomenten',
                  body:
                      'Faciliteer gestructureerde reflectie met Maria om te bepalen wat werkt, wat lastig voelt en wat de volgende prioriteit moet zijn.',
                ),
                SimulationStepDetailCopy(
                  title: 'Resultaatbeoordeling',
                  body:
                      'Evalueer de voortgang richting de SMART-doelen en bepaal of je moet opschalen, behouden of overgaan naar lichtere opvolging.',
                ),
              ],
            ),
            SimulationStepCopy(
              index: 6,
              title: 'Afronding & overgang',
              subtitle: 'Zorg voor duurzame resultaten',
              details: [
                SimulationStepDetailCopy(
                  title: 'Overdrachtsplan',
                  body:
                      'Maak een gestructureerd afbouwplan met duidelijke verantwoordelijkheden, tijdlijnen en contactpersonen voor de periode na de casus.',
                ),
                SimulationStepDetailCopy(
                  title: 'Duurzaamheidssteun',
                  body:
                      'Borg langdurige ankerpunten in de gemeenschap, praktische check-ins en zelfmanagementtools die de voortgang helpen behouden.',
                ),
                SimulationStepDetailCopy(
                  title: 'Opvolgingsschema',
                  body:
                      'Stel mijlpalen en escalatie-indicatoren vast zodat nieuwe zorgen vroeg en veilig kunnen worden opgepakt.',
                ),
              ],
            ),
          ],
          startSimulation: 'Start casussimulatie',
          downloadCase: 'Download casus',
          regenerateStep: 'Genereer deze stap opnieuw',
          editManually: 'Handmatig bewerken',
          helpButtonLabel: 'Zo werkt het',
          stepDetailsBarrierLabel: 'Stapdetails',
        );
    }
  }
}

class SimulationStepCopy {
  const SimulationStepCopy({
    required this.index,
    required this.title,
    required this.subtitle,
    required this.details,
  });

  final int index;
  final String title;
  final String subtitle;
  final List<SimulationStepDetailCopy> details;
}

class SimulationStepDetailCopy {
  const SimulationStepDetailCopy({required this.title, required this.body});

  final String title;
  final String body;
}

class DownloadSuccessCopy {
  const DownloadSuccessCopy({
    required this.downloadSuccessfulTitle,
    required this.downloadDescription,
    required this.tryYourCaseTitle,
    required this.tryYourCaseDescription,
    required this.startCaseSimulation,
    required this.generateAnotherCase,
    required this.helpButtonLabel,
  });

  final String downloadSuccessfulTitle;
  final String downloadDescription;
  final String tryYourCaseTitle;
  final String tryYourCaseDescription;
  final String startCaseSimulation;
  final String generateAnotherCase;
  final String helpButtonLabel;

  static DownloadSuccessCopy fromLanguage(AppLanguage language) {
    switch (language) {
      case AppLanguage.english:
        return const DownloadSuccessCopy(
          downloadSuccessfulTitle: 'Download\nsuccessful!',
          downloadDescription:
              'Your case has been downloaded\nsuccessfully. You can now use it in\nyour educational programs.',
          tryYourCaseTitle: 'Try your case!',
          tryYourCaseDescription:
              'Test your generated case in an\ninteractive simulation to see how it\nworks in practice.',
          startCaseSimulation: 'Start case simulation',
          generateAnotherCase: 'Generate another case',
          helpButtonLabel: 'How it works',
        );
      case AppLanguage.dutch:
        return const DownloadSuccessCopy(
          downloadSuccessfulTitle: 'Download\ngeslaagd!',
          downloadDescription:
              'Je casus is succesvol gedownload.\nJe kunt deze nu gebruiken in je\nonderwijsprogramma\'s.',
          tryYourCaseTitle: 'Test je casus!',
          tryYourCaseDescription:
              'Test je gegenereerde casus in een\ninteractieve simulatie om te zien hoe\ndeze in de praktijk werkt.',
          startCaseSimulation: 'Start casussimulatie',
          generateAnotherCase: 'Genereer nog een casus',
          helpButtonLabel: 'Zo werkt het',
        );
    }
  }
}

class HowItWorksCopy {
  const HowItWorksCopy({
    required this.barrierLabel,
    required this.title,
    required this.subtitle,
    required this.closeButtonLabel,
    required this.gotItLabel,
    required this.steps,
  });

  final String barrierLabel;
  final String title;
  final String subtitle;
  final String closeButtonLabel;
  final String gotItLabel;
  final List<HowItWorksStepCopy> steps;

  static HowItWorksCopy fromLanguage(AppLanguage language) {
    switch (language) {
      case AppLanguage.english:
        return const HowItWorksCopy(
          barrierLabel: 'How it works',
          title: 'How it works',
          subtitle:
              'Create engaging case-based learning\ncontent in three simple steps',
          closeButtonLabel: 'Close help',
          gotItLabel: 'Got it!',
          steps: [
            HowItWorksStepCopy(
              number: '1',
              title: 'Upload Your Document',
              description:
                  'Upload your case study or educational material in PDF, DOCX, or TXT format. Select your preferred language (Dutch or English).',
              icon: Icons.cloud_upload_outlined,
            ),
            HowItWorksStepCopy(
              number: '2',
              title: 'AI Generates Your Case',
              description:
                  'Our AI analyzes your document and automatically creates structured, game-based learning content following a proven six-step pedagogical model.',
              icon: Icons.auto_awesome,
            ),
            HowItWorksStepCopy(
              number: '3',
              title: 'Review & Download',
              description:
                  'Review the generated content, make any edits you need, and download your case for immediate use in your educational programs.',
              icon: Icons.download_outlined,
            ),
          ],
        );
      case AppLanguage.dutch:
        return const HowItWorksCopy(
          barrierLabel: 'Zo werkt het',
          title: 'Zo werkt het',
          subtitle:
              'Maak boeiende, casusgebaseerde leerinhoud\nin drie eenvoudige stappen',
          closeButtonLabel: 'Sluit help',
          gotItLabel: 'Begrepen!',
          steps: [
            HowItWorksStepCopy(
              number: '1',
              title: 'Upload je document',
              description:
                  'Upload je casus of lesmateriaal in PDF-, DOCX- of TXT-formaat. Kies je voorkeurstaal (Nederlands of Engels).',
              icon: Icons.cloud_upload_outlined,
            ),
            HowItWorksStepCopy(
              number: '2',
              title: 'AI maakt je casus',
              description:
                  'Onze AI analyseert je document en maakt automatisch gestructureerde, speelse leerinhoud op basis van een bewezen zesstappenmodel.',
              icon: Icons.auto_awesome,
            ),
            HowItWorksStepCopy(
              number: '3',
              title: 'Review & download',
              description:
                  'Controleer de gegenereerde inhoud, pas aan wat nodig is en download je casus voor direct gebruik in je onderwijs.',
              icon: Icons.download_outlined,
            ),
          ],
        );
    }
  }
}

class HowItWorksStepCopy {
  const HowItWorksStepCopy({
    required this.number,
    required this.title,
    required this.description,
    required this.icon,
  });

  final String number;
  final String title;
  final String description;
  final IconData icon;
}

class EvidenceItem {
  const EvidenceItem({
    required this.displayName,
    required this.sourceLabel,
    required this.icon,
  });

  final String displayName;
  final String sourceLabel;
  final IconData icon;
}
