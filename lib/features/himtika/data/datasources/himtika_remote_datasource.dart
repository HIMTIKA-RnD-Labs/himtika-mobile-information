import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/helpers/supabase_table_helper.dart';
import '../models/himtika_kabinet_model.dart';
import '../models/himtika_about_model.dart';
import '../models/himtika_divisi_model.dart';
import '../models/himtika_pengurus_model.dart';

abstract class HimtikaRemoteDataSource {
  Future<HimtikaKabinetModel?> getActiveKabinet();
  Future<void> updateKabinet(HimtikaKabinetModel kabinet);

  Future<HimtikaAboutModel?> getAboutInfo();
  Future<void> updateAboutInfo(HimtikaAboutModel about);

  Future<List<HimtikaDivisiModel>> getDivisiList();
  Future<void> createDivisi(HimtikaDivisiModel divisi);
  Future<void> updateDivisi(HimtikaDivisiModel divisi);
  Future<void> deleteDivisi(String id);

  Future<List<HimtikaPengurusModel>> getPengurusByDivisi(String divisiId);
  Future<List<HimtikaPengurusModel>> getAllPengurus();
  Future<void> createPengurus(HimtikaPengurusModel pengurus);
  Future<void> updatePengurus(HimtikaPengurusModel pengurus);
  Future<void> deletePengurus(String id);

  Future<String> uploadImage({
    required File file,
    required String bucketName,
    required String pathPrefix,
  });
}

class HimtikaRemoteDataSourceImpl implements HimtikaRemoteDataSource {
  final SupabaseClient client;

  HimtikaRemoteDataSourceImpl({required this.client});

  @override
  Future<HimtikaKabinetModel?> getActiveKabinet() async {
    final response = await SupabaseTableHelper.table('himtika_kabinet')
        .select()
        .eq('is_active', true)
        .maybeSingle();

    if (response == null) return null;
    return HimtikaKabinetModel.fromJson(response);
  }

  @override
  Future<void> updateKabinet(HimtikaKabinetModel kabinet) async {
    final data = kabinet.toJson();
    if (kabinet.id.isEmpty) {
      data.remove('id');
      await SupabaseTableHelper.table('himtika_kabinet').insert(data);
    } else {
      await SupabaseTableHelper.table('himtika_kabinet').upsert(data);
    }
  }

  @override
  Future<HimtikaAboutModel?> getAboutInfo() async {
    final response = await SupabaseTableHelper.table('himtika_about')
        .select()
        .limit(1)
        .maybeSingle();

    if (response == null) return null;
    return HimtikaAboutModel.fromJson(response);
  }

  @override
  Future<void> updateAboutInfo(HimtikaAboutModel about) async {
    final data = about.toJson();
    if (about.id.isEmpty) {
      data.remove('id');
      await SupabaseTableHelper.table('himtika_about').insert(data);
    } else {
      await SupabaseTableHelper.table('himtika_about').upsert(data);
    }
  }

  static const List<Map<String, dynamic>> _seedDivisions = [
    {'nama_divisi': 'Steering Committee', 'urutan': 0},
    {'nama_divisi': 'Divisi Internal', 'urutan': 1},
    {'nama_divisi': 'Divisi RnD', 'urutan': 2},
    {'nama_divisi': 'Divisi Relasi', 'urutan': 3},
    {'nama_divisi': 'Divisi Edukasi', 'urutan': 4},
    {'nama_divisi': 'Divisi Infokom', 'urutan': 5},
  ];

  @override
  Future<List<HimtikaDivisiModel>> getDivisiList() async {
    final response = await SupabaseTableHelper.table('himtika_divisi')
        .select()
        .order('urutan', ascending: true);

    var list = response as List<dynamic>;
    if (list.isEmpty) {
      try {
        final inserted = await SupabaseTableHelper.table('himtika_divisi')
            .insert(_seedDivisions)
            .select();
        list = inserted as List<dynamic>;
      } catch (_) {
        // Fallback jika permission atau offline
      }
    }
    return list.map((e) => HimtikaDivisiModel.fromJson(e)).toList();
  }

  @override
  Future<void> createDivisi(HimtikaDivisiModel divisi) async {
    final data = divisi.toJson();
    data.remove('id');
    await SupabaseTableHelper.table('himtika_divisi').insert(data);
  }

  @override
  Future<void> updateDivisi(HimtikaDivisiModel divisi) async {
    final data = divisi.toJson();
    data.remove('id');
    await SupabaseTableHelper.table('himtika_divisi')
        .update(data)
        .eq('id', divisi.id);
  }

  @override
  Future<void> deleteDivisi(String id) async {
    await SupabaseTableHelper.table('himtika_divisi')
        .delete()
        .eq('id', id);
  }

  @override
  Future<List<HimtikaPengurusModel>> getPengurusByDivisi(String divisiId) async {
    final response = await SupabaseTableHelper.table('himtika_pengurus')
        .select()
        .eq('divisi_id', divisiId)
        .order('urutan', ascending: true);

    final list = response as List<dynamic>;
    return list.map((e) => HimtikaPengurusModel.fromJson(e)).toList();
  }

  @override
  Future<List<HimtikaPengurusModel>> getAllPengurus() async {
    final response = await SupabaseTableHelper.table('himtika_pengurus')
        .select()
        .order('urutan', ascending: true);

    final list = response as List<dynamic>;
    return list.map((e) => HimtikaPengurusModel.fromJson(e)).toList();
  }

  @override
  Future<void> createPengurus(HimtikaPengurusModel pengurus) async {
    final data = pengurus.toJson();
    data.remove('id');
    await SupabaseTableHelper.table('himtika_pengurus').insert(data);
  }

  @override
  Future<void> updatePengurus(HimtikaPengurusModel pengurus) async {
    await SupabaseTableHelper.table('himtika_pengurus')
        .update(pengurus.toJson())
        .eq('id', pengurus.id);
  }

  @override
  Future<void> deletePengurus(String id) async {
    await SupabaseTableHelper.table('himtika_pengurus')
        .delete()
        .eq('id', id);
  }

  @override
  Future<String> uploadImage({
    required File file,
    required String bucketName,
    required String pathPrefix,
  }) async {
    final baseName = file.path.split(RegExp(r'[/\\]')).last;
    final fileName = '${DateTime.now().millisecondsSinceEpoch}_$baseName';
    final filePath = '$pathPrefix/$fileName';

    final bytes = await file.readAsBytes();
    await client.storage.from(bucketName).uploadBinary(
      filePath,
      bytes,
      fileOptions: const FileOptions(upsert: true),
    );
    return client.storage.from(bucketName).getPublicUrl(filePath);
  }
}
