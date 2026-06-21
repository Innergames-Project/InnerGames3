/// The 8 collectable intervention cards in Sociality.
enum InterventionCard {
  individueel,
  collectief,
  informeel,
  formeel,
  meedoen,       // Sociaaleconomische Zekerheid
  jezelfZijn,    // Sociale Empowerment
  ertoeDoen,     // Sociale Inclusie
  erbijHoren,    // Sociale Cohesie
}

extension InterventionCardLabel on InterventionCard {
  String get label {
    switch (this) {
      case InterventionCard.individueel: return 'Individueel';
      case InterventionCard.collectief:  return 'Collectief';
      case InterventionCard.informeel:   return 'Informeel';
      case InterventionCard.formeel:     return 'Formeel';
      case InterventionCard.meedoen:     return 'Meedoen';
      case InterventionCard.jezelfZijn:  return 'Jezelf Zijn';
      case InterventionCard.ertoeDoen:   return 'Ertoe Doen';
      case InterventionCard.erbijHoren:  return 'Erbij Horen';
    }
  }
}

/// Resolves which InterventionCards an intervention entry unlocks.
List<InterventionCard> resolveCards(Map<String, dynamic> intervention) {
  final unlocked = <InterventionCard>[];

  final scope = intervention['scope'] as String?;
  final formality = intervention['formality'] as String?;
  final condition = (intervention['aspect']?['condition'] as String?)?.toLowerCase();

  if (scope == 'individual') unlocked.add(InterventionCard.individueel);
  if (scope == 'collective') unlocked.add(InterventionCard.collectief);
  if (formality == 'formal')   unlocked.add(InterventionCard.formeel);
  if (formality == 'informal') unlocked.add(InterventionCard.informeel);

  if (condition != null) {
    if (condition.contains('cohesion'))  unlocked.add(InterventionCard.erbijHoren);
    if (condition.contains('empowerment')) unlocked.add(InterventionCard.jezelfZijn);
    if (condition.contains('inclusion'))   unlocked.add(InterventionCard.ertoeDoen);
    if (condition.contains('economic'))    unlocked.add(InterventionCard.meedoen);
  }

  return unlocked;
}

/// Returns the full set of InterventionCards unlocked by a consequence card.
Set<InterventionCard> unlockedByConsequence(Map<String, dynamic> consequenceCard) {
  final interventions = consequenceCard['interventions'] as List<dynamic>? ?? [];
  final result = <InterventionCard>{};
  for (final i in interventions) {
    result.addAll(resolveCards(i as Map<String, dynamic>));
  }
  return result;
}