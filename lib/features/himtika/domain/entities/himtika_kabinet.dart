import 'package:equatable/equatable.dart';

class HimtikaKabinet extends Equatable {
  final String id;
  final String namaKabinet;
  final String? tagline;
  final String? deskripsi;
  final String? logoUrl;
  final String periode;
  final bool isActive;
  final List<Map<String, String>> nilaiKabinet;
  final List<Map<String, String>> maknaLogo;

  const HimtikaKabinet({
    required this.id,
    required this.namaKabinet,
    this.tagline,
    this.deskripsi,
    this.logoUrl,
    required this.periode,
    this.isActive = true,
    this.nilaiKabinet = const [],
    this.maknaLogo = const [],
  });

  HimtikaKabinet copyWith({
    String? id,
    String? namaKabinet,
    String? tagline,
    String? deskripsi,
    String? logoUrl,
    String? periode,
    bool? isActive,
    List<Map<String, String>>? nilaiKabinet,
    List<Map<String, String>>? maknaLogo,
  }) {
    return HimtikaKabinet(
      id: id ?? this.id,
      namaKabinet: namaKabinet ?? this.namaKabinet,
      tagline: tagline ?? this.tagline,
      deskripsi: deskripsi ?? this.deskripsi,
      logoUrl: logoUrl ?? this.logoUrl,
      periode: periode ?? this.periode,
      isActive: isActive ?? this.isActive,
      nilaiKabinet: nilaiKabinet ?? this.nilaiKabinet,
      maknaLogo: maknaLogo ?? this.maknaLogo,
    );
  }

  @override
  List<Object?> get props => [
        id,
        namaKabinet,
        tagline,
        deskripsi,
        logoUrl,
        periode,
        isActive,
        nilaiKabinet,
        maknaLogo,
      ];
}
