import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:himtika_mobile_information/features/himtika/data/datasources/himtika_default_structure.dart';
import 'package:himtika_mobile_information/features/himtika/domain/entities/himtika_pengurus.dart';
import 'package:himtika_mobile_information/features/himtika/domain/entities/himtika_divisi.dart';
import 'package:himtika_mobile_information/features/AdminPanel/presentation/bloc/himtika_management/himtika_management_bloc.dart';
import 'package:himtika_mobile_information/features/AdminPanel/presentation/bloc/himtika_management/himtika_management_event.dart';
import 'package:himtika_mobile_information/features/AdminPanel/presentation/bloc/himtika_management/himtika_management_state.dart';

class HimtikaPengurusTab extends StatefulWidget {
  const HimtikaPengurusTab({super.key});

  @override
  State<HimtikaPengurusTab> createState() => _HimtikaPengurusTabState();
}

class _HimtikaPengurusTabState extends State<HimtikaPengurusTab> {
  final ImagePicker _picker = ImagePicker();
  String _selectedDivision = HimtikaDefaultStructure.divisionNames.first;

  HimtikaDivisi _findDivisi(HimtikaManagementState state, String divisionName) {
    final cleanTarget =
        divisionName.toLowerCase().replaceAll('divisi ', '').trim();
    return state.divisiList.firstWhere(
      (d) =>
          d.namaDivisi.toLowerCase().replaceAll('divisi ', '').trim() ==
          cleanTarget,
      orElse: () => HimtikaDivisi(
        id: '',
        namaDivisi: divisionName,
        urutan: 0,
      ),
    );
  }

  void _showEditFotoDialog(
    BuildContext context, {
    required DefaultMember defaultMember,
    required HimtikaPengurus? customPengurus,
    required String divisiId,
  }) {
    final bloc = context.read<HimtikaManagementBloc>();
    final formKey = GlobalKey<FormState>();
    final namaController = TextEditingController(
      text: customPengurus?.nama ?? defaultMember.name,
    );
    final jabatanController = TextEditingController(
      text: customPengurus?.jabatan ?? defaultMember.position,
    );

    File? selectedFotoFile;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogInnerContext, setDialogState) {
            Future<void> pickFoto() async {
              final XFile? picked = await _picker.pickImage(
                source: ImageSource.gallery,
                imageQuality: 85,
              );
              if (picked != null) {
                setDialogState(() {
                  selectedFotoFile = File(picked.path);
                });
              }
            }

            final bool hasNetwork = customPengurus?.fotoUrl != null &&
                customPengurus!.fotoUrl!.isNotEmpty;

            ImageProvider imageProvider;
            if (selectedFotoFile != null) {
              imageProvider = FileImage(selectedFotoFile!);
            } else if (hasNetwork) {
              imageProvider = NetworkImage(customPengurus.fotoUrl!);
            } else {
              imageProvider = AssetImage(defaultMember.defaultAsset);
            }

            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  const Icon(Icons.camera_alt, color: Color(0xFF0175C8)),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Ubah Foto Pengurus',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Preview Avatar
                      GestureDetector(
                        onTap: pickFoto,
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 46,
                              backgroundColor: const Color(0xFF0175C8)
                                  .withValues(alpha: 0.1),
                              backgroundImage: imageProvider,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: CircleAvatar(
                                radius: 15,
                                backgroundColor: const Color(0xFF0175C8),
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton.icon(
                        onPressed: pickFoto,
                        icon: const Icon(Icons.photo_library, size: 16),
                        label: const Text('Pilih dari Galeri'),
                      ),
                      const SizedBox(height: 12),

                      // Nama Pengurus
                      TextFormField(
                        controller: namaController,
                        decoration: InputDecoration(
                          labelText: 'Nama Pengurus *',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                                ? 'Nama wajib diisi'
                                : null,
                      ),
                      const SizedBox(height: 12),

                      // Jabatan (Read-only / info)
                      TextFormField(
                        controller: jabatanController,
                        decoration: InputDecoration(
                          labelText: 'Jabatan (Posisi Resmi)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                                ? 'Jabatan wajib diisi'
                                : null,
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Batal',
                      style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0175C8),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      if (customPengurus == null) {
                        final newPengurus = HimtikaPengurus(
                          id: '',
                          divisiId: divisiId,
                          nama: namaController.text.trim(),
                          jabatan: jabatanController.text.trim(),
                          urutan: defaultMember.urutan,
                        );
                        bloc.add(CreatePengurusEvent(
                          pengurus: newPengurus,
                          fotoFile: selectedFotoFile,
                        ));
                      } else {
                        final updated = customPengurus.copyWith(
                          divisiId: divisiId,
                          nama: namaController.text.trim(),
                          jabatan: jabatanController.text.trim(),
                          urutan: defaultMember.urutan,
                        );
                        bloc.add(UpdatePengurusEvent(
                          pengurus: updated,
                          fotoFile: selectedFotoFile,
                        ));
                      }
                      Navigator.pop(dialogContext);
                    }
                  },
                  child: const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAddCustomPengurusDialog(
    BuildContext context, {
    required String divisiId,
  }) {
    if (divisiId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Divisi belum ditemukan di database. Pastikan data divisi sudah tersimpan.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    final bloc = context.read<HimtikaManagementBloc>();
    final formKey = GlobalKey<FormState>();
    final namaController = TextEditingController();
    final jabatanController = TextEditingController();
    File? selectedFotoFile;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogInnerContext, setDialogState) {
            Future<void> pickFoto() async {
              final XFile? picked = await _picker.pickImage(
                source: ImageSource.gallery,
                imageQuality: 85,
              );
              if (picked != null) {
                setDialogState(() {
                  selectedFotoFile = File(picked.path);
                });
              }
            }

            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Row(
                children: [
                  Icon(Icons.person_add, color: Color(0xFF0175C8)),
                  SizedBox(width: 8),
                  Text('Tambah Anggota Baru',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: pickFoto,
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor:
                              const Color(0xFF0175C8).withValues(alpha: 0.1),
                          backgroundImage: selectedFotoFile != null
                              ? FileImage(selectedFotoFile!)
                              : null,
                          child: selectedFotoFile == null
                              ? const Icon(Icons.camera_alt,
                                  size: 32, color: Color(0xFF0175C8))
                              : null,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton.icon(
                        onPressed: pickFoto,
                        icon: const Icon(Icons.photo_library, size: 16),
                        label: const Text('Pilih Foto'),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: namaController,
                        decoration: InputDecoration(
                          labelText: 'Nama Pengurus *',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                                ? 'Nama wajib diisi'
                                : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: jabatanController,
                        decoration: InputDecoration(
                          labelText: 'Jabatan (Contoh: Anggota Dept. HRD) *',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                                ? 'Jabatan wajib diisi'
                                : null,
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Batal',
                      style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0175C8),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      final newPengurus = HimtikaPengurus(
                        id: '',
                        divisiId: divisiId,
                        nama: namaController.text.trim(),
                        jabatan: jabatanController.text.trim(),
                        urutan: 99,
                      );
                      bloc.add(CreatePengurusEvent(
                        pengurus: newPengurus,
                        fotoFile: selectedFotoFile,
                      ));
                      Navigator.pop(dialogContext);
                    }
                  },
                  child: const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEditCustomMemberDialog(
    BuildContext context, {
    required HimtikaPengurus pengurus,
  }) {
    final bloc = context.read<HimtikaManagementBloc>();
    final formKey = GlobalKey<FormState>();
    final namaController = TextEditingController(text: pengurus.nama);
    final jabatanController = TextEditingController(text: pengurus.jabatan);
    File? selectedFotoFile;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            Future<void> pickFoto() async {
              final picked =
                  await _picker.pickImage(source: ImageSource.gallery);
              if (picked != null) {
                setDialogState(() {
                  selectedFotoFile = File(picked.path);
                });
              }
            }

            ImageProvider? avatarImage;
            if (selectedFotoFile != null) {
              avatarImage = FileImage(selectedFotoFile!);
            } else if (pengurus.fotoUrl != null &&
                pengurus.fotoUrl!.isNotEmpty) {
              avatarImage = NetworkImage(pengurus.fotoUrl!);
            }

            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Row(
                children: [
                  Icon(Icons.edit, color: Color(0xFF0175C8)),
                  SizedBox(width: 8),
                  Text('Edit Anggota',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: pickFoto,
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor:
                              const Color(0xFF0175C8).withValues(alpha: 0.1),
                          backgroundImage: avatarImage,
                          child: avatarImage == null
                              ? const Icon(Icons.camera_alt,
                                  size: 32, color: Color(0xFF0175C8))
                              : null,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton.icon(
                        onPressed: pickFoto,
                        icon: const Icon(Icons.photo_library, size: 16),
                        label: const Text('Ganti Foto'),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: namaController,
                        decoration: InputDecoration(
                          labelText: 'Nama Pengurus *',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                                ? 'Nama wajib diisi'
                                : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: jabatanController,
                        decoration: InputDecoration(
                          labelText: 'Jabatan (Contoh: Anggota Dept. HRD) *',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                                ? 'Jabatan wajib diisi'
                                : null,
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Batal',
                      style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0175C8),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      final updated = pengurus.copyWith(
                        nama: namaController.text.trim(),
                        jabatan: jabatanController.text.trim(),
                      );
                      bloc.add(UpdatePengurusEvent(
                        pengurus: updated,
                        fotoFile: selectedFotoFile,
                      ));
                      Navigator.pop(dialogContext);
                    }
                  },
                  child: const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmDeleteAdditional(BuildContext context, HimtikaPengurus pengurus) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Anggota?'),
        content: Text(
          'Anggota ${pengurus.nama} (${pengurus.jabatan}) akan dihapus secara permanen dari divisi ini.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              context
                  .read<HimtikaManagementBloc>()
                  .add(DeletePengurusEvent(pengurusId: pengurus.id));
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _confirmReset(BuildContext context, HimtikaPengurus pengurus) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Kembalikan ke Foto Bawaan?'),
        content: Text(
          'Foto kustom untuk ${pengurus.nama} (${pengurus.jabatan}) akan dihapus dan kembali menggunakan foto bawaan resmi.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              context
                  .read<HimtikaManagementBloc>()
                  .add(DeletePengurusEvent(pengurusId: pengurus.id));
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
        final currentDivisi = _findDivisi(state, _selectedDivision);
        final defaultMembers =
            HimtikaDefaultStructure.getMembersByDivision(_selectedDivision);

        final matchedPengurusIds = <String>{};
        for (final member in defaultMembers) {
          HimtikaPengurus? custom;
          if (currentDivisi.id.isNotEmpty) {
            custom = state.pengurusList.where((p) {
              return p.divisiId == currentDivisi.id && p.urutan == member.urutan;
            }).firstOrNull;
          }
          if (custom == null) {
            custom = state.pengurusList.where((p) {
              final sameName = p.nama.trim().toLowerCase() == member.name.trim().toLowerCase();
              if (currentDivisi.id.isNotEmpty) {
                return sameName && p.divisiId == currentDivisi.id;
              }
              return sameName;
            }).firstOrNull;
          }
          if (custom == null) {
            custom = state.pengurusList.where((p) {
              final pName = p.nama.trim().toLowerCase();
              final mName = member.name.trim().toLowerCase();
              final isSimilar = pName.contains(mName) || mName.contains(pName);
              final sameJabatan = p.jabatan.trim().toLowerCase() == member.position.trim().toLowerCase();
              if (currentDivisi.id.isNotEmpty) {
                return isSimilar && sameJabatan && p.divisiId == currentDivisi.id;
              }
              return isSimilar && sameJabatan;
            }).firstOrNull;
          }
          if (custom != null) {
            matchedPengurusIds.add(custom.id);
          }
        }

        final additionalMembers = state.pengurusList.where((p) {
          final matchDivisi = currentDivisi.id.isNotEmpty
              ? p.divisiId == currentDivisi.id
              : false;
          return matchDivisi && !matchedPengurusIds.contains(p.id);
        }).toList();

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
                // Header & Division Selector
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Pilih Divisi:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color(0xFF0175C8),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedDivision,
                              isExpanded: true,
                              items: HimtikaDefaultStructure.divisionNames
                                  .map((name) {
                                return DropdownMenuItem<String>(
                                  value: name,
                                  child: Text(
                                    name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() {
                                    _selectedDivision = val;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0175C8)
                                .withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.info_outline,
                                  size: 20, color: Color(0xFF0175C8)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Klik "Ganti Foto" pada anggota untuk mengunggah foto baru. Tata letak dan deskripsi divisi tetap terjaga rapi.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Subheader
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Daftar Anggota (${defaultMembers.length + additionalMembers.length})',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => _showAddCustomPengurusDialog(
                        context,
                        divisiId: currentDivisi.id,
                      ),
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('Tambah Anggota',
                          style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Members List
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: defaultMembers.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final member = defaultMembers[index];

                    // Cari apakah pengurus ini sudah diupdate di Supabase
                    HimtikaPengurus? custom;

                    // 1. Cocokkan urutan slot & divisi spesifik
                    if (currentDivisi.id.isNotEmpty) {
                      custom = state.pengurusList.where((p) {
                        return p.divisiId == currentDivisi.id && p.urutan == member.urutan;
                      }).firstOrNull;
                    }

                    // 2. Cocokkan nama lengkap persis (case-insensitive)
                    if (custom == null) {
                      custom = state.pengurusList.where((p) {
                        final sameName = p.nama.trim().toLowerCase() == member.name.trim().toLowerCase();
                        if (currentDivisi.id.isNotEmpty) {
                          return sameName && p.divisiId == currentDivisi.id;
                        }
                        return sameName;
                      }).firstOrNull;
                    }

                    // 3. Cocokkan kemiripan nama dengan jabatan yang sama
                    if (custom == null) {
                      custom = state.pengurusList.where((p) {
                        final pName = p.nama.trim().toLowerCase();
                        final mName = member.name.trim().toLowerCase();
                        final isSimilar = pName.contains(mName) || mName.contains(pName);
                        final sameJabatan = p.jabatan.trim().toLowerCase() == member.position.trim().toLowerCase();
                        if (currentDivisi.id.isNotEmpty) {
                          return isSimilar && sameJabatan && p.divisiId == currentDivisi.id;
                        }
                        return isSimilar && sameJabatan;
                      }).firstOrNull;
                    }

                    final bool isCustom = custom?.fotoUrl != null &&
                        custom!.fotoUrl!.isNotEmpty;
                    final displayName = custom?.nama ?? member.name;

                    ImageProvider imageProvider;
                    if (isCustom) {
                      imageProvider = NetworkImage(custom.fotoUrl!);
                    } else {
                      imageProvider = AssetImage(member.defaultAsset);
                    }

                    return Card(
                      elevation: 1.5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        child: Row(
                          children: [
                            // Avatar
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image(
                                image: imageProvider,
                                width: 56,
                                height: 56,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 56,
                                  height: 56,
                                  color: Colors.grey.shade300,
                                  child: const Icon(Icons.person,
                                      color: Colors.grey),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Jabatan & Nama
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    member.position,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Color(0xFF0175C8),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    displayName,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: isCustom
                                          ? Colors.green.shade50
                                          : Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: isCustom
                                            ? Colors.green.shade300
                                            : Colors.grey.shade300,
                                      ),
                                    ),
                                    child: Text(
                                      isCustom ? 'Foto Kustom' : 'Foto Bawaan',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: isCustom
                                            ? Colors.green.shade700
                                            : Colors.grey.shade600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Actions
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  tooltip: 'Ganti Foto',
                                  icon: const Icon(Icons.camera_alt_outlined,
                                      color: Color(0xFF0175C8)),
                                  onPressed: () => _showEditFotoDialog(
                                    context,
                                    defaultMember: member,
                                    customPengurus: custom,
                                    divisiId: currentDivisi.id,
                                  ),
                                ),
                                if (isCustom)
                                  IconButton(
                                    tooltip: 'Kembalikan ke Foto Bawaan',
                                    icon: const Icon(Icons.restore,
                                        color: Colors.orange),
                                    onPressed: () =>
                                        _confirmReset(context, custom!),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                if (additionalMembers.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Icon(Icons.group_add_outlined,
                          size: 20, color: Color(0xFF0175C8)),
                      const SizedBox(width: 8),
                      Text(
                        'Anggota Tambahan (${additionalMembers.length})',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0175C8),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: additionalMembers.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final member = additionalMembers[index];
                      final bool hasFoto = member.fotoUrl != null &&
                          member.fotoUrl!.isNotEmpty;

                      return Card(
                        elevation: 1.5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          child: Row(
                            children: [
                              // Avatar
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: hasFoto
                                    ? Image.network(
                                        member.fotoUrl!,
                                        width: 56,
                                        height: 56,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Container(
                                          width: 56,
                                          height: 56,
                                          color: Colors.grey.shade300,
                                          child: const Icon(Icons.person,
                                              color: Colors.grey),
                                        ),
                                      )
                                    : Container(
                                        width: 56,
                                        height: 56,
                                        color: Colors.grey.shade200,
                                        child: const Icon(Icons.person,
                                            color: Colors.grey),
                                      ),
                              ),
                              const SizedBox(width: 12),

                              // Jabatan & Nama
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      member.jabatan,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Color(0xFF0175C8),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      member.nama,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey.shade800,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade50,
                                        borderRadius:
                                            BorderRadius.circular(6),
                                        border: Border.all(
                                          color: Colors.blue.shade300,
                                        ),
                                      ),
                                      child: Text(
                                        'Anggota Tambahan',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.blue.shade700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Actions
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    tooltip: 'Edit Anggota',
                                    icon: const Icon(Icons.edit_outlined,
                                        color: Color(0xFF0175C8)),
                                    onPressed: () =>
                                        _showEditCustomMemberDialog(
                                      context,
                                      pengurus: member,
                                    ),
                                  ),
                                  IconButton(
                                    tooltip: 'Hapus Anggota',
                                    icon: const Icon(Icons.delete_outline,
                                        color: Colors.redAccent),
                                    onPressed: () =>
                                        _confirmDeleteAdditional(
                                      context,
                                      member,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
