class ReservaResult {
  final String detail;
  final String? whatsappLink;
  final DateTime? vencimiento;

  const ReservaResult({
    required this.detail,
    this.whatsappLink,
    this.vencimiento,
  });
}
