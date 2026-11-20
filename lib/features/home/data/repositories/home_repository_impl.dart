import '../../domain/entities/home_banner.dart';
import '../../domain/entities/division.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_datasource.dart';
import '../models/home_banner_model.dart';
import 'package:himtika_mobile_information/core/injection_container.dart';
import 'package:himtika_mobile_information/features/himtika/domain/entities/himtika_divisi.dart';
import 'package:himtika_mobile_information/features/himtika/domain/repositories/himtika_repository.dart';
import 'package:himtika_mobile_information/features/himtika/data/datasources/himtika_default_structure.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDatasource remoteDatasource;
  final HimtikaRepository? himtikaRepository;

  HomeRepositoryImpl({
    required this.remoteDatasource,
    this.himtikaRepository,
  });

  @override
  Future<List<HomeBanner>> getHomeBanners() async {
    try {
      final data = await remoteDatasource.getBanners();
      return data.map((map) => HomeBannerModel.fromMap(map)).toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<List<Division>> getDivisions() async {
    List<HimtikaDivisi> divisiList = [];
    try {
      if (himtikaRepository != null) {
        divisiList = await himtikaRepository!.getDivisiList();
      } else if (sl.isRegistered<HimtikaRepository>()) {
        divisiList = await sl<HimtikaRepository>().getDivisiList();
      }
    } catch (_) {
      // Fallback ke default
    }

    return HimtikaDefaultStructure.defaultDivisions.map((defDiv) {
      final cleanTarget =
          defDiv.name.toLowerCase().replaceAll('divisi ', '').trim();

      final match = divisiList.where((d) {
        final cleanD =
            d.namaDivisi.toLowerCase().replaceAll('divisi ', '').trim();
        return cleanD == cleanTarget;
      }).firstOrNull;

      final customUrl = match?.logoUrl;
      final hasCustom = customUrl != null && customUrl.isNotEmpty;

      return Division(
        id: match?.id ?? defDiv.name,
        name: defDiv.name,
        logoUrl: hasCustom ? customUrl : defDiv.defaultCardAsset,
        order: defDiv.urutan,
        isCustom: hasCustom,
      );
    }).toList();
  }
}