class FilamentModel {
  final String id;
  final String brand;
  final String name;
  final String materialType; // PLA, PETG, ABS, TPU etc.
  final double pricePerKg; // 1 Kg Fiyatı (TL)

  FilamentModel({
    required this.id,
    required this.brand,
    required this.name,
    required this.materialType,
    required this.pricePerKg,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'brand': brand,
        'name': name,
        'materialType': materialType,
        'pricePerKg': pricePerKg,
      };

  factory FilamentModel.fromJson(Map<String, dynamic> json) => FilamentModel(
        id: json['id'] as String,
        brand: json['brand'] as String,
        name: json['name'] as String,
        materialType: json['materialType'] as String,
        pricePerKg: (json['pricePerKg'] as num).toDouble(),
      );

  static List<FilamentModel> get defaultPresets => [
        FilamentModel(
          id: 'preset_pla',
          brand: 'Standart',
          name: 'PLA Filament',
          materialType: 'PLA',
          pricePerKg: 650.0,
        ),
        FilamentModel(
          id: 'preset_petg',
          brand: 'Standart',
          name: 'PETG Filament',
          materialType: 'PETG',
          pricePerKg: 750.0,
        ),
        FilamentModel(
          id: 'preset_abs',
          brand: 'Standart',
          name: 'ABS Filament',
          materialType: 'ABS',
          pricePerKg: 700.0,
        ),
        FilamentModel(
          id: 'preset_tpu',
          brand: 'Esnek',
          name: 'TPU 95A Filament',
          materialType: 'TPU',
          pricePerKg: 1100.0,
        ),
      ];
}
