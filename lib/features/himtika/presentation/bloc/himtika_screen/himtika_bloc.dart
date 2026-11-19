import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/repositories/himtika_repository.dart';

part 'himtika_event.dart';
part 'himtika_state.dart';

class HimtikaBloc extends Bloc<HimtikaEvent, HimtikaState> {
  final HimtikaRepository? repository;

  HimtikaBloc({this.repository}) : super(const HimtikaState()) {
    on<FetchHimtikaData>(_onFetchHimtikaData);
  }

  Future<void> _onFetchHimtikaData(
      FetchHimtikaData event, Emitter<HimtikaState> emit) async {
    emit(state.copyWith(status: HimtikaStatus.loading));

    String kabinetName = 'SINERGIS';
    String kabinetTagline =
        'Sinergi, Inovatif, Eksplorasi, Responsif, Generalis, Sistematis';
    String kabinetLogoPath = 'src/features/himtika/images/kabinet.png';

    try {
      if (repository != null) {
        final activeKabinet = await repository!.getActiveKabinet();
        if (activeKabinet != null) {
          if (activeKabinet.namaKabinet.isNotEmpty) {
            kabinetName = activeKabinet.namaKabinet;
          }
          if (activeKabinet.tagline != null && activeKabinet.tagline!.isNotEmpty) {
            kabinetTagline = activeKabinet.tagline!;
          } else if (activeKabinet.nilaiKabinet.isNotEmpty) {
            final titles = activeKabinet.nilaiKabinet
                .map((e) => e['title'] ?? '')
                .where((t) => t.isNotEmpty)
                .toList();
            if (titles.isNotEmpty) {
              kabinetTagline = titles.join(', ');
            }
          }
          if (activeKabinet.logoUrl != null && activeKabinet.logoUrl!.isNotEmpty) {
            kabinetLogoPath = activeKabinet.logoUrl!;
          }
        }
      }
    } catch (_) {
      // Fallback to default
    }

    // Data Dummy untuk "Bagian Penting"
    final dummyImportantParts = [
      {
        'id': 'sc',
        'imagePath': 'src/features/himtika/divisi/sc/sc.png',
        'title': 'Steering Committee',
      },
      {
        'id': 'internal',
        'imagePath': 'src/features/himtika/divisi/internal/internal.png',
        'title': 'Divisi Internal',
      },
      {
        'id': 'rnd',
        'imagePath': 'src/features/himtika/divisi/rnd/rnd.png',
        'title': 'Divisi RnD',
      },
      {
        'id': 'relasi',
        'imagePath': 'src/features/himtika/divisi/relasi/relasi.png',
        'title': 'Divisi Relasi',
      },
      {
        'id': 'edukasi',
        'imagePath': 'src/features/himtika/divisi/edukasi/edukasi.png',
        'title': 'Divisi Edukasi',
      },
      {
        'id': 'infokom',
        'imagePath': 'src/features/himtika/divisi/infokom/infokom.png',
        'title': 'Divisi Infokom',
      },
    ];

    List<Map<String, String>> importantParts = dummyImportantParts;

    try {
      if (repository != null) {
        final activeKabinet = await repository!.getActiveKabinet();
        if (activeKabinet != null) {
          if (activeKabinet.namaKabinet.isNotEmpty) {
            kabinetName = activeKabinet.namaKabinet;
          }
          if (activeKabinet.tagline != null && activeKabinet.tagline!.isNotEmpty) {
            kabinetTagline = activeKabinet.tagline!;
          } else if (activeKabinet.nilaiKabinet.isNotEmpty) {
            final titles = activeKabinet.nilaiKabinet
                .map((e) => e['title'] ?? '')
                .where((t) => t.isNotEmpty)
                .toList();
            if (titles.isNotEmpty) {
              kabinetTagline = titles.join(', ');
            }
          }
          if (activeKabinet.logoUrl != null && activeKabinet.logoUrl!.isNotEmpty) {
            kabinetLogoPath = activeKabinet.logoUrl!;
          }
        }

        final divisiList = await repository!.getDivisiList();
        if (divisiList.isNotEmpty) {
          importantParts = divisiList.map((divisi) {
            String imagePath = '';
            if (divisi.logoUrl != null && divisi.logoUrl!.isNotEmpty) {
              imagePath = divisi.logoUrl!;
            } else {
              imagePath = _resolveDefaultDivisiImage(divisi.namaDivisi);
            }
            return {
              'id': divisi.id,
              'title': divisi.namaDivisi,
              'imagePath': imagePath,
            };
          }).toList();
        }
      }
    } catch (_) {
      // Fallback to default
    }

    emit(state.copyWith(
      status: HimtikaStatus.success,
      importantParts: importantParts,
      kabinetName: kabinetName,
      kabinetTagline: kabinetTagline,
      kabinetLogoPath: kabinetLogoPath,
    ));
  }

  static String _resolveDefaultDivisiImage(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('steering') || lower == 'sc') {
      return 'src/features/himtika/divisi/sc/sc.png';
    }
    if (lower.contains('internal')) {
      return 'src/features/himtika/divisi/internal/internal.png';
    }
    if (lower.contains('rnd') || lower.contains('r&d')) {
      return 'src/features/himtika/divisi/rnd/rnd.png';
    }
    if (lower.contains('relasi')) {
      return 'src/features/himtika/divisi/relasi/relasi.png';
    }
    if (lower.contains('edukasi')) {
      return 'src/features/himtika/divisi/edukasi/edukasi.png';
    }
    if (lower.contains('infokom')) {
      return 'src/features/himtika/divisi/infokom/infokom.png';
    }
    return '';
  }
}