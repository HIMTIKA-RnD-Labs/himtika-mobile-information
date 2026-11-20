import '../../domain/entities/division.dart';

class DivisionModel extends Division {
  const DivisionModel({
    required super.id,
    required super.name,
    required super.logoUrl,
    required super.order,
    super.isCustom,
  });

  factory DivisionModel.fromMap(Map<String, dynamic> map) {
    final logo = map['logo_url']?.toString() ?? '';
    final isCustom = logo.startsWith('http://') || logo.startsWith('https://');
    return DivisionModel(
      id: map['id']?.toString() ?? '',
      name: (map['nama_divisi'] ?? map['name'] ?? '').toString(),
      logoUrl: logo,
      order: map['urutan'] ?? map['order'] ?? 0,
      isCustom: isCustom,
    );
  }
}