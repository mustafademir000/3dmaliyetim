class CalculationResult {
  final double filamentCost;
  final double electricityCost;
  final double depreciationCost;
  final double laborCost;
  final double subtotalBaseCost;
  final double failureRiskCost;
  final double totalProductionCost;
  final double profitAmount;
  final double netProductPrice; // Production + Profit
  final double vatPercent; // KDV % (e.g. 20%)
  final double vatAmount; // KDV tutarı
  final double priceWithVat; // Net Product Price + KDV Amount
  final double commissionPercent; // Komisyon % (e.g. 15%)
  final double commissionAmount; // Calculated on priceWithVat!
  final double cargoCost; // Kargo ücreti (TL)
  final double finalCustomerPrice; // priceWithVat + commissionAmount + cargoCost

  CalculationResult({
    required this.filamentCost,
    required this.electricityCost,
    required this.depreciationCost,
    required this.laborCost,
    required this.subtotalBaseCost,
    required this.failureRiskCost,
    required this.totalProductionCost,
    required this.profitAmount,
    required this.netProductPrice,
    required this.vatPercent,
    required this.vatAmount,
    required this.priceWithVat,
    required this.commissionPercent,
    required this.commissionAmount,
    required this.cargoCost,
    required this.finalCustomerPrice,
  });

  double get profitMarginPercent =>
      totalProductionCost > 0 ? (profitAmount / totalProductionCost) * 100 : 0;

  double get filamentPercentage =>
      totalProductionCost > 0 ? (filamentCost / totalProductionCost) * 100 : 0;
  double get electricityPercentage =>
      totalProductionCost > 0 ? (electricityCost / totalProductionCost) * 100 : 0;
  double get depreciationPercentage =>
      totalProductionCost > 0 ? (depreciationCost / totalProductionCost) * 100 : 0;
  double get laborPercentage =>
      totalProductionCost > 0 ? (laborCost / totalProductionCost) * 100 : 0;
  double get failurePercentage =>
      totalProductionCost > 0 ? (failureRiskCost / totalProductionCost) * 100 : 0;

  Map<String, dynamic> toJson() => {
        'filamentCost': filamentCost,
        'electricityCost': electricityCost,
        'depreciationCost': depreciationCost,
        'laborCost': laborCost,
        'subtotalBaseCost': subtotalBaseCost,
        'failureRiskCost': failureRiskCost,
        'totalProductionCost': totalProductionCost,
        'profitAmount': profitAmount,
        'netProductPrice': netProductPrice,
        'vatPercent': vatPercent,
        'vatAmount': vatAmount,
        'priceWithVat': priceWithVat,
        'commissionPercent': commissionPercent,
        'commissionAmount': commissionAmount,
        'cargoCost': cargoCost,
        'finalCustomerPrice': finalCustomerPrice,
      };

  factory CalculationResult.fromJson(Map<String, dynamic> json) => CalculationResult(
        filamentCost: (json['filamentCost'] as num).toDouble(),
        electricityCost: (json['electricityCost'] as num).toDouble(),
        depreciationCost: (json['depreciationCost'] as num).toDouble(),
        laborCost: (json['laborCost'] as num).toDouble(),
        subtotalBaseCost: (json['subtotalBaseCost'] as num).toDouble(),
        failureRiskCost: (json['failureRiskCost'] as num).toDouble(),
        totalProductionCost: (json['totalProductionCost'] as num).toDouble(),
        profitAmount: (json['profitAmount'] as num).toDouble(),
        netProductPrice: (json['netProductPrice'] as num? ?? 0.0).toDouble(),
        vatPercent: (json['vatPercent'] as num? ?? 20.0).toDouble(),
        vatAmount: (json['vatAmount'] as num? ?? 0.0).toDouble(),
        priceWithVat: (json['priceWithVat'] as num? ?? 0.0).toDouble(),
        commissionPercent: (json['commissionPercent'] as num? ?? 0.0).toDouble(),
        commissionAmount: (json['commissionAmount'] as num? ?? 0.0).toDouble(),
        cargoCost: (json['cargoCost'] as num? ?? 0.0).toDouble(),
        finalCustomerPrice: (json['finalCustomerPrice'] as num? ?? 0.0).toDouble(),
      );
}
