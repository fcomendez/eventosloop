enum ReportContentType {
  post,
  event,
}

enum ReportReason {
  spam,
  harassment,
  misinformation,
  inappropriate,
  impersonation,
  other,
}

extension ReportReasonLabels on ReportReason {
  String get title {
    return switch (this) {
      ReportReason.spam => 'Spam o contenido repetitivo',
      ReportReason.harassment => 'Acoso o discurso de odio',
      ReportReason.misinformation => 'Información falsa o engañosa',
      ReportReason.inappropriate => 'Contenido inapropiado o violento',
      ReportReason.impersonation => 'Suplantación de identidad',
      ReportReason.other => 'Otro motivo',
    };
  }

  String get description {
    return switch (this) {
      ReportReason.spam =>
        'Publicaciones duplicadas, promociones no deseadas o enlaces sospechosos.',
      ReportReason.harassment =>
        'Insultos, amenazas, bullying o ataques contra personas o grupos.',
      ReportReason.misinformation =>
        'Datos falsos sobre eventos, lugares, fechas o identidades.',
      ReportReason.inappropriate =>
        'Contenido sexual, violento o que incumple las normas de la comunidad.',
      ReportReason.impersonation =>
        'Alguien se hace pasar por otra persona u organización.',
      ReportReason.other => 'Describe con detalle lo ocurrido en el campo de abajo.',
    };
  }
}

class ReportContentRequest {
  const ReportContentRequest({
    required this.contentType,
    required this.contentId,
    required this.contentTitle,
    required this.reason,
    this.description,
  });

  final ReportContentType contentType;
  final int contentId;
  final String contentTitle;
  final ReportReason reason;
  final String? description;
}
