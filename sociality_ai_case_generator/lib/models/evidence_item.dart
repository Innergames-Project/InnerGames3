import 'package:flutter/material.dart';

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
