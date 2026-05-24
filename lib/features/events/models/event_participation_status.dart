enum EventParticipationStatus {
  none,
  pending,
  approved,
  rejected,
}

extension EventParticipationStatusLabels on EventParticipationStatus {
  String get dbValue => switch (this) {
        EventParticipationStatus.none => '',
        EventParticipationStatus.pending => 'PENDIENTE',
        EventParticipationStatus.approved => 'APROBADO',
        EventParticipationStatus.rejected => 'RECHAZADO',
      };

  static EventParticipationStatus fromDb(String? value) {
    return switch (value?.toUpperCase()) {
      'PENDIENTE' => EventParticipationStatus.pending,
      'APROBADO' => EventParticipationStatus.approved,
      'RECHAZADO' => EventParticipationStatus.rejected,
      _ => EventParticipationStatus.none,
    };
  }
}
