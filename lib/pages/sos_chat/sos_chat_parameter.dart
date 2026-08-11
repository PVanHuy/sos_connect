class SosChatParameter {
  const SosChatParameter({required this.sosId, this.title, this.readOnly = false});

  final String sosId;
  final String? title;

  final bool readOnly;
}
