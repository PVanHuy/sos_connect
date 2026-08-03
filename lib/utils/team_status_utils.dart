import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sos_connect/main.dart';

enum TeamStatusFilter { all, pending, approved, rejected }

extension TeamStatusFilterExtension on TeamStatusFilter {
  String get nameKey {
    switch (this) {
      case TeamStatusFilter.all:
        return 'all';
      case TeamStatusFilter.pending:
        return 'team_status_pending';
      case TeamStatusFilter.approved:
        return 'team_status_approved';
      case TeamStatusFilter.rejected:
        return 'team_status_rejected';
    }
  }

  String get displayName => nameKey.tr;

  String? get statusValue {
    switch (this) {
      case TeamStatusFilter.all:
        return null;
      case TeamStatusFilter.pending:
        return TeamStatusUtils.pending;
      case TeamStatusFilter.approved:
        return TeamStatusUtils.approved;
      case TeamStatusFilter.rejected:
        return TeamStatusUtils.rejected;
    }
  }
}

class TeamStatusUtils {
  static const String pending = 'pending';
  static const String approved = 'approved';
  static const String rejected = 'rejected';
}

class TeamStatusStyle {
  final Color background;
  final Color text;
  final Color border;

  const TeamStatusStyle({required this.background, required this.text, required this.border});
}

extension TeamStatusExtension on String? {
  bool get isTeamPending => (this ?? '').toLowerCase() == TeamStatusUtils.pending;
  bool get isTeamApproved => (this ?? '').toLowerCase() == TeamStatusUtils.approved;
  bool get isTeamRejected => (this ?? '').toLowerCase() == TeamStatusUtils.rejected;

  String get teamStatusName {
    switch ((this ?? '').toLowerCase()) {
      case TeamStatusUtils.pending:
        return 'team_status_pending'.tr;
      case TeamStatusUtils.approved:
        return 'team_status_approved'.tr;
      case TeamStatusUtils.rejected:
        return 'team_status_rejected'.tr;
      default:
        return (this ?? '').toString();
    }
  }

  TeamStatusStyle get teamStatusStyle {
    switch ((this ?? '').toLowerCase()) {
      case TeamStatusUtils.pending:
        return TeamStatusStyle(
          background: const Color(0xFFFFF7E6),
          text: appTheme.yellow22Color,
          border: appTheme.yellow22Color,
        );
      case TeamStatusUtils.approved:
        return TeamStatusStyle(
          background: appTheme.bgGreenColor,
          text: appTheme.green47Color,
          border: appTheme.green47Color,
        );
      case TeamStatusUtils.rejected:
        return TeamStatusStyle(background: appTheme.redF4Color, text: appTheme.red55Color, border: appTheme.red55Color);
      default:
        return TeamStatusStyle(
          background: appTheme.grayF1Color,
          text: appTheme.oldSliverColor,
          border: appTheme.oldSliverColor,
        );
    }
  }
}
