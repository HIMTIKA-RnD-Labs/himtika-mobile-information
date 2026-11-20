import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:himtika_mobile_information/features/himtika/data/datasources/himtika_default_structure.dart';
import 'package:himtika_mobile_information/features/himtika/domain/entities/himtika_divisi.dart';
import 'package:himtika_mobile_information/features/AdminPanel/presentation/bloc/himtika_management/himtika_management_bloc.dart';
import 'package:himtika_mobile_information/features/AdminPanel/presentation/bloc/himtika_management/himtika_management_event.dart';
import 'package:himtika_mobile_information/features/AdminPanel/presentation/bloc/himtika_management/himtika_management_state.dart';

class HimtikaDivisiTab extends StatefulWidget {
  const HimtikaDivisiTab({super.key});

  @override
  State<HimtikaDivisiTab> createState() => _HimtikaDivisiTabState();
}

class _HimtikaDivisiTabState extends State<HimtikaDivisiTab> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickAndUploadCard(
    BuildContext context, {
    required DefaultDivision defaultDivision,
    required HimtikaDivisi? existingDivisi,
  }) async {
    final XFile? picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked == null) return;

    if (!context.mounted) return;
    final bloc = context.read<HimtikaManagementBloc>();
    final file = File(picked.path);

    if (existingDivisi != null && existingDivisi.id.isNotEmpty) {
      bloc.add(UpdateDivisiEvent(
        divisi: existingDivisi,
        logoFile: file,
      ));
    } else {
      final newDivisi = HimtikaDivisi(
        id: '',
        namaDivisi: defaultDivision.name,
        urutan: defaultDivision.urutan,
      );
      bloc.add(CreateDivisiEvent(
        divisi: newDivisi,
        logoFile: file,
      ));
    }
  }

  void _confirmReset(
    BuildContext context, {
    required DefaultDivision defaultDivision,
    required HimtikaDivisi existingDivisi,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Kembalikan Foto Card Bawaan?'),
        content: Text(
          'Foto card untuk "${defaultDivision.name}" akan dikembalikan ke foto bawaan resmi.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              context.read<HimtikaManagementBloc>().add(
                    UpdateDivisiEvent(
                      divisi: existingDivisi.copyWith(logoUrl: ''),
                    ),
                  );
            },
            child: const Text('Kembalikan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HimtikaManagementBloc, HimtikaManagementState>(
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () async {
            context
                .read<HimtikaManagementBloc>()
                .add(const FetchHimtikaAdminData());
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Info Box
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0175C8).withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF0175C8).withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline,
                          size: 24, color: Color(0xFF0175C8)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Kelola 6 foto card divisi yang tampil pada section "Bagian Penting dalam HIMTIKA" di halaman depan.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade800,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // List 6 Card Divisi
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: HimtikaDefaultStructure.defaultDivisions.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final defaultDiv =
                        HimtikaDefaultStructure.defaultDivisions[index];
                    final cleanTarget = defaultDiv.name
                        .toLowerCase()
                        .replaceAll('divisi ', '')
                        .trim();

                    final existing = state.divisiList.where((d) {
                      final cleanD = d.namaDivisi
                          .toLowerCase()
                          .replaceAll('divisi ', '')
                          .trim();
                      return cleanD == cleanTarget;
                    }).firstOrNull;

                    final bool hasCustom = existing?.logoUrl != null &&
                        existing!.logoUrl!.isNotEmpty;
                    final String cardImage = hasCustom
                        ? existing.logoUrl!
                        : defaultDiv.defaultCardAsset;
                    final bool isNetwork = cardImage.startsWith('http://') ||
                        cardImage.startsWith('https://');

                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Card Image Preview
                          Container(
                            height: 140,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFF0175C8),
                              image: DecorationImage(
                                image: isNetwork
                                    ? NetworkImage(cardImage) as ImageProvider
                                    : AssetImage(cardImage),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: hasCustom
                                ? Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withValues(alpha: 0.15),
                                          Colors.black.withValues(alpha: 0.8),
                                        ],
                                      ),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 12),
                                    alignment: Alignment.bottomLeft,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            defaultDiv.name,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              shadows: [
                                                Shadow(
                                                  offset: Offset(0, 1),
                                                  blurRadius: 3,
                                                  color: Colors.black87,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.white,
                                          size: 14,
                                        ),
                                      ],
                                    ),
                                  )
                                : null,
                          ),

                          // Card Details & Actions
                          Padding(
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        defaultDiv.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Color(0xFF0175C8),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: hasCustom
                                              ? Colors.green.shade50
                                              : Colors.grey.shade100,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          border: Border.all(
                                            color: hasCustom
                                                ? Colors.green.shade300
                                                : Colors.grey.shade300,
                                          ),
                                        ),
                                        child: Text(
                                          hasCustom
                                              ? 'Foto Kustom'
                                              : 'Foto Bawaan',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: hasCustom
                                                ? Colors.green.shade700
                                                : Colors.grey.shade600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Action Buttons
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF0175C8),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                  ),
                                  icon: const Icon(Icons.camera_alt_outlined,
                                      size: 16),
                                  label: const Text('Ganti Card',
                                      style: TextStyle(fontSize: 12)),
                                  onPressed: () => _pickAndUploadCard(
                                    context,
                                    defaultDivision: defaultDiv,
                                    existingDivisi: existing,
                                  ),
                                ),
                                if (hasCustom) ...[
                                  const SizedBox(width: 8),
                                  IconButton(
                                    tooltip: 'Kembalikan Foto Bawaan',
                                    icon: const Icon(Icons.restore,
                                        color: Colors.orange),
                                    onPressed: () => _confirmReset(
                                      context,
                                      defaultDivision: defaultDiv,
                                      existingDivisi: existing,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
