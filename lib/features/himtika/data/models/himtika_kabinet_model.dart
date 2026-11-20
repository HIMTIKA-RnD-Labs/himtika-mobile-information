import '../../domain/entities/himtika_kabinet.dart';

class HimtikaKabinetModel extends HimtikaKabinet {
  const HimtikaKabinetModel({
    required super.id,
    required super.namaKabinet,
    super.tagline,
    super.deskripsi,
    super.logoUrl,
    required super.periode,
    super.isActive,
    super.nilaiKabinet,
    super.maknaLogo,
    super.warnaNama,
  });

  factory HimtikaKabinetModel.fromJson(Map<String, dynamic> json) {
    List<Map<String, String>> parsedNilai = [];
    if (json['nilai_kabinet'] != null) {
      final rawList = json['nilai_kabinet'] as List<dynamic>;
      parsedNilai = rawList.map((item) {
        if (item is Map) {
          return {
            'title': item['title']?.toString() ?? '',
            'description': item['description']?.toString() ?? '',
          };
        }
        return <String, String>{};
      }).where((item) => item.isNotEmpty).toList();
    }

    List<Map<String, String>> parsedMaknaLogo = [];
    if (json['makna_logo'] != null) {
      final rawList = json['makna_logo'] as List<dynamic>;
      parsedMaknaLogo = rawList.map((item) {
        if (item is Map) {
          return {
            'icon': item['icon']?.toString() ?? '',
            'title': item['title']?.toString() ?? '',
            'description': item['description']?.toString() ?? '',
          };
        }
        return <String, String>{};
      }).where((item) => item.isNotEmpty).toList();
    }

    String? warnaNama = json['warna_nama'] as String?;
    final metaIndex =
        parsedNilai.indexWhere((e) => e['title'] == '__warna_nama__');
    if (metaIndex != -1) {
      if (warnaNama == null || warnaNama.isEmpty) {
        warnaNama = parsedNilai[metaIndex]['description'];
      }
      parsedNilai.removeWhere((e) => e['title'] == '__warna_nama__');
    }

    return HimtikaKabinetModel(
      id: json['id'] as String,
      namaKabinet: json['nama_kabinet'] as String? ?? '',
      tagline: json['tagline'] as String?,
      deskripsi: json['deskripsi'] as String?,
      logoUrl: json['logo_url'] as String?,
      periode: json['periode'] as String? ?? '',
      isActive: json['is_active'] as bool? ?? true,
      nilaiKabinet: parsedNilai,
      maknaLogo: parsedMaknaLogo,
      warnaNama: warnaNama,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_kabinet': namaKabinet,
      'tagline': tagline,
      'deskripsi': deskripsi,
      'logo_url': logoUrl,
      'periode': periode,
      'is_active': isActive,
      'nilai_kabinet': nilaiKabinet,
      'makna_logo': maknaLogo,
      if (warnaNama != null && warnaNama!.isNotEmpty) 'warna_nama': warnaNama,
    };
  }
}
