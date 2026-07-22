class PrinterModel {
  final String id;
  final String name;
  final double powerConsumptionWatts; // e.g. 200W
  final double hourlyWearCost; // e.g. 10 TL/saat

  PrinterModel({
    required this.id,
    required this.name,
    required this.powerConsumptionWatts,
    required this.hourlyWearCost,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'powerConsumptionWatts': powerConsumptionWatts,
        'hourlyWearCost': hourlyWearCost,
      };

  factory PrinterModel.fromJson(Map<String, dynamic> json) => PrinterModel(
        id: json['id'] as String,
        name: json['name'] as String,
        powerConsumptionWatts: (json['powerConsumptionWatts'] as num).toDouble(),
        hourlyWearCost: (json['hourlyWearCost'] as num).toDouble(),
      );

  static List<PrinterModel> get defaultPresets => [
        PrinterModel(
          id: 'preset_snapmaker_u1',
          name: 'Snapmaker U1',
          powerConsumptionWatts: 200.0,
          hourlyWearCost: 10.0,
        ),
        PrinterModel(
          id: 'preset_bambu_x1c',
          name: 'Bambu Lab X1C / P1S',
          powerConsumptionWatts: 160.0,
          hourlyWearCost: 10.0,
        ),
        PrinterModel(
          id: 'preset_ender3',
          name: 'Creality Ender 3 / V2',
          powerConsumptionWatts: 120.0,
          hourlyWearCost: 5.0,
        ),
      ];
}
