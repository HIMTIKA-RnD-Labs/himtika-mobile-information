import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:himtika_mobile_information/features/himtika/data/datasources/himtika_default_structure.dart';
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

    // 6 Divisi penting dalam HIMTIKA (default aset dengan override dari database)
    final importantParts = HimtikaDefaultStructure.defaultDivisions.map((defDiv) {
      return {
        'imagePath': defDiv.defaultCardAsset,
        'title': defDiv.name,
      };
    }).toList();

    try {
      if (repository != null) {
        final divisiList = await repository!.getDivisiList();
        if (divisiList.isNotEmpty) {
          for (final part in importantParts) {
            final cleanTitle =
                part['title']!.toLowerCase().replaceAll('divisi ', '').trim();
            final match = divisiList.where((d) {
              final cleanD =
                  d.namaDivisi.toLowerCase().replaceAll('divisi ', '').trim();
              return cleanD == cleanTitle;
            }).firstOrNull;

            if (match?.logoUrl != null && match!.logoUrl!.isNotEmpty) {
              part['imagePath'] = match.logoUrl!;
            }
          }
        }
      }
    } catch (_) {
      // Fallback to default assets
    }

    emit(state.copyWith(
      status: HimtikaStatus.success,
      importantParts: importantParts,
      kabinetName: kabinetName,
      kabinetTagline: kabinetTagline,
      kabinetLogoPath: kabinetLogoPath,
    ));
  }
}