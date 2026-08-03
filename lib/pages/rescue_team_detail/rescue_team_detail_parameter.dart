class RescueTeamDetailParameter {
  const RescueTeamDetailParameter({
    required this.teamId,
    this.hasPendingJoinRequest = false,
  });

  final String teamId;
  final bool hasPendingJoinRequest;
}
