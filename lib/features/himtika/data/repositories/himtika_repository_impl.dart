import 'dart:io';
import '../../domain/entities/himtika_kabinet.dart';
import '../../domain/entities/himtika_about.dart';
import '../../domain/entities/himtika_divisi.dart';
import '../../domain/entities/himtika_pengurus.dart';
import '../../domain/repositories/himtika_repository.dart';
import '../datasources/himtika_remote_datasource.dart';
import '../models/himtika_kabinet_model.dart';
import '../models/himtika_about_model.dart';
import '../models/himtika_divisi_model.dart';
import '../models/himtika_pengurus_model.dart';

class HimtikaRepositoryImpl implements HimtikaRepository {
  final HimtikaRemoteDataSource remoteDataSource;

  HimtikaRepositoryImpl({required this.remoteDataSource});

  @override
  Future<HimtikaKabinet?> getActiveKabinet() async {
    return await remoteDataSource.getActiveKabinet();
  }

  @override
  Future<void> updateKabinet(HimtikaKabinet kabinet) async {
    final model = HimtikaKabinetModel(
      id: kabinet.id,
      namaKabinet: kabinet.namaKabinet,
      tagline: kabinet.tagline,
      deskripsi: kabinet.deskripsi,
      logoUrl: kabinet.logoUrl,
      periode: kabinet.periode,
      isActive: kabinet.isActive,
      nilaiKabinet: kabinet.nilaiKabinet,
      maknaLogo: kabinet.maknaLogo,
      warnaNama: kabinet.warnaNama,
    );
    await remoteDataSource.updateKabinet(model);
  }

  @override
  Future<HimtikaAbout?> getAboutInfo() async {
    return await remoteDataSource.getAboutInfo();
  }

  @override
  Future<void> updateAboutInfo(HimtikaAbout about) async {
    final model = HimtikaAboutModel(
      id: about.id,
      visi: about.visi,
      misi: about.misi,
      sejarahText: about.sejarahText,
    );
    await remoteDataSource.updateAboutInfo(model);
  }

  @override
  Future<List<HimtikaDivisi>> getDivisiList() async {
    final list = await remoteDataSource.getDivisiList();
    return List<HimtikaDivisi>.from(list);
  }

  @override
  Future<void> createDivisi(HimtikaDivisi divisi) async {
    final model = HimtikaDivisiModel(
      id: divisi.id,
      namaDivisi: divisi.namaDivisi,
      deskripsi: divisi.deskripsi,
      logoUrl: divisi.logoUrl,
      urutan: divisi.urutan,
    );
    await remoteDataSource.createDivisi(model);
  }

  @override
  Future<void> updateDivisi(HimtikaDivisi divisi) async {
    final model = HimtikaDivisiModel(
      id: divisi.id,
      namaDivisi: divisi.namaDivisi,
      deskripsi: divisi.deskripsi,
      logoUrl: divisi.logoUrl,
      urutan: divisi.urutan,
    );
    await remoteDataSource.updateDivisi(model);
  }

  @override
  Future<void> deleteDivisi(String id) async {
    await remoteDataSource.deleteDivisi(id);
  }

  @override
  Future<List<HimtikaPengurus>> getPengurusByDivisi(String divisiId) async {
    final list = await remoteDataSource.getPengurusByDivisi(divisiId);
    return List<HimtikaPengurus>.from(list);
  }

  @override
  Future<List<HimtikaPengurus>> getAllPengurus() async {
    final list = await remoteDataSource.getAllPengurus();
    return List<HimtikaPengurus>.from(list);
  }

  @override
  Future<void> createPengurus(HimtikaPengurus pengurus) async {
    final model = HimtikaPengurusModel(
      id: pengurus.id,
      divisiId: pengurus.divisiId,
      nama: pengurus.nama,
      jabatan: pengurus.jabatan,
      fotoUrl: pengurus.fotoUrl,
      urutan: pengurus.urutan,
    );
    await remoteDataSource.createPengurus(model);
  }

  @override
  Future<void> updatePengurus(HimtikaPengurus pengurus) async {
    final model = HimtikaPengurusModel(
      id: pengurus.id,
      divisiId: pengurus.divisiId,
      nama: pengurus.nama,
      jabatan: pengurus.jabatan,
      fotoUrl: pengurus.fotoUrl,
      urutan: pengurus.urutan,
    );
    await remoteDataSource.updatePengurus(model);
  }

  @override
  Future<void> deletePengurus(String id) async {
    await remoteDataSource.deletePengurus(id);
  }

  @override
  Future<String> uploadImage({
    required File file,
    required String bucketName,
    required String pathPrefix,
  }) async {
    return await remoteDataSource.uploadImage(
      file: file,
      bucketName: bucketName,
      pathPrefix: pathPrefix,
    );
  }
}
