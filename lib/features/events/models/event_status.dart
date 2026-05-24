enum EventStatus {
  active,
  suspended,
  deleted,
}

extension EventStatusLabels on EventStatus {
  String get dbValue => switch (this) {
        EventStatus.active => 'ACTIVO',
        EventStatus.suspended => 'SUSPENDIDO',
        EventStatus.deleted => 'ELIMINADO',
      };

  String get label => switch (this) {
        EventStatus.active => 'Activo',
        EventStatus.suspended => 'Suspendido',
        EventStatus.deleted => 'Eliminado',
      };

  static EventStatus fromDb(String? value) {
    return switch (value?.toUpperCase()) {
      'SUSPENDIDO' => EventStatus.suspended,
      'ELIMINADO' => EventStatus.deleted,
      _ => EventStatus.active,
    };
  }
}
