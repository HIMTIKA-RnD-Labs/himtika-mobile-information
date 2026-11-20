import '../../domain/entities/home_banner.dart';
import '../../domain/entities/division.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_datasource.dart';
import '../models/home_banner_model.dart';
import 'package:himtika_mobile_information/features/himtika/data/datasources/himtika_default_structure.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDatasource remoteDatasource;

  HomeRepositoryImpl({required this.remoteDatasource});

  @override
  Future<List<HomeBanner>> getHomeBanners() async {
    final data = await remoteDatasource.getBanners();
    return data.map((map) => HomeBannerModel.fromMap(map)).toList();
  }

  @override
  Future<List<Division>> getDivisions() async {
    List<Map<String, dynamic>> data = [];
    try {
      data = await remoteDatasource.getDivisions();
    } catch (_) {
      // Fallback to default
    }

    return HimtikaDefaultStructure.defaultDivisions.map((defDiv) {
      final cleanTarget =
          defDiv.name.toLowerCase().replaceAll('divisi ', '').trim();

      final match = data.where((map) {
        final name = (map['nama_divisi'] ?? map['name'] ?? '')
            .toString()
            .toLowerCase()
            .replaceAll('divisi ', '')
            .trim();
        return name == cleanTarget;
      }).firstOrNull;

      final customUrl = match?['logo_url']?.toString();
      final hasCustom = customUrl != null && customUrl.isNotEmpty;

      return Division(
        id: match?['id']?.toString() ?? defDiv.name,
        name: defDiv.name,
        logoUrl: hasCustom ? customUrl : defDiv.defaultCardAsset,
        order: defDiv.urutan,
        isCustom: hasCustom,
      );
    }).toList();
  }
}