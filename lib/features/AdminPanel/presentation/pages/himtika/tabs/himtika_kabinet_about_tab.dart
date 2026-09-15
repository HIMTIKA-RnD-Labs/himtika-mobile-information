import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:himtika_mobile_information/features/himtika/domain/entities/himtika_kabinet.dart';
import 'package:himtika_mobile_information/features/himtika/domain/entities/himtika_about.dart';
import 'package:himtika_mobile_information/features/AdminPanel/presentation/bloc/himtika_management/himtika_management_bloc.dart';
import 'package:himtika_mobile_information/features/AdminPanel/presentation/bloc/himtika_management/himtika_management_event.dart';
import 'package:himtika_mobile_information/features/AdminPanel/presentation/bloc/himtika_management/himtika_management_state.dart';

class HimtikaKabinetAboutTab extends StatefulWidget {
  const HimtikaKabinetAboutTab({super.key});

  @override
  State<HimtikaKabinetAboutTab> createState() => _HimtikaKabinetAboutTabState();
}

class _HimtikaKabinetAboutTabState extends State<HimtikaKabinetAboutTab> {
  final _formKeyKabinet = GlobalKey<FormState>();
  final _formKeyAbout = GlobalKey<FormState>();

  late TextEditingController _namaKabinetController;
  late TextEditingController _taglineController;
  late TextEditingController _deskripsiKabinetController;
  late TextEditingController _periodeController;

  late TextEditingController _visiController;
  late TextEditingController _sejarahController;
  final List<TextEditingController> _misiControllers = [];

  final List<TextEditingController> _nilaiTitleControllers = [];
  final List<TextEditingController> _nilaiDescControllers = [];

  final List<TextEditingController> _maknaLogoTitleControllers = [];
  final List<TextEditingController> _maknaLogoDescControllers = [];
  final List<String> _maknaLogoIconUrls = [];
  final Map<int, File> _maknaLogoSelectedFiles = {};

  File? _selectedLogoFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _namaKabinetController = TextEditingController();
    _taglineController = TextEditingController();
    _deskripsiKabinetController = TextEditingController();
    _periodeController = TextEditingController();

    _visiController = TextEditingController();
    _sejarahController = TextEditingController();

    _initDataFromState(context.read<HimtikaManagementBloc>().state);
  }

  static const List<Map<String, String>> defaultNilaiKabinet = [
    {
      'title': 'Sinergi',
      'description':
          'Mengembangkan HIMTIKA sebagai sebuah Organisasi aktif yang menaungi dan bersinergi dengan Mahasiswa Informatika UNSIKA... Nilai Sinergi ini menjadi hal utama yang diaktualisasikan agar HIMTIKA dapat menghimpun dan Mewadahi Mahasiswa Informatika untuk menjalin rasa kekeluargaan yang solid dan saling mendukung untuk mencapai peningkatan prestasi dan mewujudkan tujuan bersama'
    },
    {
      'title': 'Inovatif',
      'description':
          'Inovatif adalah sesuatu yang bersifat pengembangan dan pembaruan. Maksud dari inovatif HIMTIKA harus mampu menciptakan ruang yang mendukung Inovasi untuk memberikan kesempatan bagi Mahasiswa Informatika mengembangkan ide dan gagasannya'
    },
    {
      'title': 'Eksplorasi',
      'description':
          'Adalah upaya mencari dan mengembangkan ide-ide, pengetahuan, atau cara-cara baru yang dapat mendorong inovasi. Dalam hal ini diharapkan HIMTIKA berkontribusi untuk mendukung Mahasiswa Informatika untuk mencari dan mendapatkan pengetahuan lebih luas dan lebih menyeluruh'
    },
    {
      'title': 'Responsif',
      'description':
          'Adalah kemampuan untuk memberikan tanggapan atau reaksi yang cepat, tepat, dan sesuai terhadap suatu kondisi. Diharapkan HIMTIKA dapat merespon semua kebutuhan dan keinginan Mahasiswa Informatika dengan cepat dan tepat, khususnya yang berkaitan dengan bidang Keilmuan dan Akademik'
    },
    {
      'title': 'Generalis',
      'description':
          'Diartikan sebagai sesuatu hal yang mencakup banyak bidang. Berdasarkan hal ini HIMTIKA harus berhasil mewadahi setiap aspek potensial Mahasiswa dalam berbagai bidang, dan memahami atau menangani berbagai topik ataupun permasalahan yang relevan'
    },
    {
      'title': 'Sistematis',
      'description':
          'Merujuk pada cara berpikir atau cara bekerja yang mengikuti urutan yang logis, terencana, dan konsisten. HIMTIKA akan mengadaptasi struktural yang lebih terorganisir dan terencana untuk menjalankan sebuah Organisasi yang berjalan dengan cara yang efisien, terkoordinir, dan terarah pada tujuan yang jelas'
    },
  ];

  static const List<Map<String, String>> defaultMaknaLogo = [
    {
      'icon': 'src/features/himtika/kabinet/angsa.png',
      'title': 'Angsa',
      'description':
          'Melambangkan harmoni yang diharapkan dapat dirasakan dan dipelihara serta dijaga oleh segenap pengurus dan anggota HIMTIKA',
    },
    {
      'icon': 'src/features/himtika/kabinet/teratai.png',
      'title': 'Bunga Teratai',
      'description':
          '8 Kelopak bunga teratai melambangkan pertumbuhan HIMTIKA yang mencapai generasi ke delapan dan tetap bertumbuh berkembang menjadi organisasi yang bermanfaat',
    },
    {
      'icon': 'src/features/himtika/kabinet/daun.png',
      'title': 'Daun',
      'description':
          '6 daun merefleksikan enam nilai utama yang akan dibangun dalam kepengurusan yaitu Sinergi, Inovatif, Eksplorasi, Responsif, Generalis, dan Sistematis',
    },
    {
      'icon': 'src/features/himtika/kabinet/gear.png',
      'title': 'Gear',
      'description':
          'Melambangkan teknologi dan keberlanjutan yang dinamis dan terus bergerak membangun sumber daya mahasiswa yang kreatif, kompetitif, dan unggul',
    },
  ];

  void _initDataFromState(HimtikaManagementState state) {
    if (state.kabinet != null) {
      _namaKabinetController.text = state.kabinet!.namaKabinet;
      _taglineController.text = state.kabinet!.tagline ?? '';
      _deskripsiKabinetController.text = state.kabinet!.deskripsi ?? '';
      _periodeController.text = state.kabinet!.periode;

      for (var c in _nilaiTitleControllers) {
        c.dispose();
      }
      for (var c in _nilaiDescControllers) {
        c.dispose();
      }
      _nilaiTitleControllers.clear();
      _nilaiDescControllers.clear();

      final listToUse = state.kabinet!.nilaiKabinet.isNotEmpty
          ? state.kabinet!.nilaiKabinet
          : defaultNilaiKabinet;

      for (var item in listToUse) {
        _nilaiTitleControllers.add(TextEditingController(text: item['title'] ?? ''));
        _nilaiDescControllers.add(TextEditingController(text: item['description'] ?? ''));
      }

      for (var c in _maknaLogoTitleControllers) {
        c.dispose();
      }
      for (var c in _maknaLogoDescControllers) {
        c.dispose();
      }
      _maknaLogoTitleControllers.clear();
      _maknaLogoDescControllers.clear();
      _maknaLogoIconUrls.clear();
      _maknaLogoSelectedFiles.clear();

      final maknaListToUse = state.kabinet!.maknaLogo.isNotEmpty
          ? state.kabinet!.maknaLogo
          : defaultMaknaLogo;

      for (var item in maknaListToUse) {
        _maknaLogoTitleControllers.add(TextEditingController(text: item['title'] ?? ''));
        _maknaLogoDescControllers.add(TextEditingController(text: item['description'] ?? ''));
        _maknaLogoIconUrls.add(item['icon'] ?? '');
      }
    } else {
      if (_namaKabinetController.text.isEmpty) {
        _namaKabinetController.text = 'SINERGIS';
        _taglineController.text = 'Sinergi, Inovatif, Eksplorasi, Responsif, Generalis, Sistematis';
        _periodeController.text = '2024/2025';
        _deskripsiKabinetController.text = 'Sinergis mencerminkan nilai-nilai utama yang dijunjung tinggi oleh kami, yaitu Sinergi, Inovatif, Eksplorasi, Responsif, Generalis, dan Sistematis. Setiap elemen dalam logo kami melambangkan komitmen kami untuk memberikan kontribusi nyata pada masyarakat informatika.';

        for (var c in _nilaiTitleControllers) {
          c.dispose();
        }
        for (var c in _nilaiDescControllers) {
          c.dispose();
        }
        _nilaiTitleControllers.clear();
        _nilaiDescControllers.clear();

        for (var item in defaultNilaiKabinet) {
          _nilaiTitleControllers.add(TextEditingController(text: item['title'] ?? ''));
          _nilaiDescControllers.add(TextEditingController(text: item['description'] ?? ''));
        }

        for (var c in _maknaLogoTitleControllers) {
          c.dispose();
        }
        for (var c in _maknaLogoDescControllers) {
          c.dispose();
        }
        _maknaLogoTitleControllers.clear();
        _maknaLogoDescControllers.clear();
        _maknaLogoIconUrls.clear();
        _maknaLogoSelectedFiles.clear();

        for (var item in defaultMaknaLogo) {
          _maknaLogoTitleControllers.add(TextEditingController(text: item['title'] ?? ''));
          _maknaLogoDescControllers.add(TextEditingController(text: item['description'] ?? ''));
          _maknaLogoIconUrls.add(item['icon'] ?? '');
        }
      }
    }

    if (state.about != null) {
      _visiController.text = state.about!.visi;
      _sejarahController.text = state.about!.sejarahText;

      for (var controller in _misiControllers) {
        controller.dispose();
      }
      _misiControllers.clear();

      for (String item in state.about!.misi) {
        _misiControllers.add(TextEditingController(text: item));
      }
      if (_misiControllers.isEmpty) {
        _misiControllers.add(TextEditingController());
      }
    }
  }

  @override
  void dispose() {
    _namaKabinetController.dispose();
    _taglineController.dispose();
    _deskripsiKabinetController.dispose();
    _periodeController.dispose();

    _visiController.dispose();
    _sejarahController.dispose();
    for (var c in _misiControllers) {
      c.dispose();
    }
    for (var c in _nilaiTitleControllers) {
      c.dispose();
    }
    for (var c in _nilaiDescControllers) {
      c.dispose();
    }
    for (var c in _maknaLogoTitleControllers) {
      c.dispose();
    }
    for (var c in _maknaLogoDescControllers) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickLogoImage() async {
    final XFile? picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked != null) {
      setState(() {
        _selectedLogoFile = File(picked.path);
      });
    }
  }

  void _addMisiField() {
    setState(() {
      _misiControllers.add(TextEditingController());
    });
  }

  void _removeMisiField(int index) {
    if (_misiControllers.length > 1) {
      setState(() {
        _misiControllers[index].dispose();
        _misiControllers.removeAt(index);
      });
    } else {
      _misiControllers[0].clear();
    }
  }

  void _addNilaiField() {
    setState(() {
      _nilaiTitleControllers.add(TextEditingController());
      _nilaiDescControllers.add(TextEditingController());
    });
  }

  void _removeNilaiField(int index) {
    setState(() {
      _nilaiTitleControllers[index].dispose();
      _nilaiTitleControllers.removeAt(index);
      _nilaiDescControllers[index].dispose();
      _nilaiDescControllers.removeAt(index);
    });
  }

  Future<void> _pickMaknaLogoImage(int index) async {
    final XFile? picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked != null) {
      setState(() {
        _maknaLogoSelectedFiles[index] = File(picked.path);
      });
    }
  }

  void _addMaknaLogoField() {
    setState(() {
      _maknaLogoTitleControllers.add(TextEditingController());
      _maknaLogoDescControllers.add(TextEditingController());
      _maknaLogoIconUrls.add('');
    });
  }

  void _removeMaknaLogoField(int index) {
    setState(() {
      _maknaLogoTitleControllers[index].dispose();
      _maknaLogoTitleControllers.removeAt(index);
      _maknaLogoDescControllers[index].dispose();
      _maknaLogoDescControllers.removeAt(index);
      if (index < _maknaLogoIconUrls.length) {
        _maknaLogoIconUrls.removeAt(index);
      }
      _maknaLogoSelectedFiles.remove(index);
      final newFiles = <int, File>{};
      for (final entry in _maknaLogoSelectedFiles.entries) {
        if (entry.key > index) {
          newFiles[entry.key - 1] = entry.value;
        } else if (entry.key < index) {
          newFiles[entry.key] = entry.value;
        }
      }
      _maknaLogoSelectedFiles.clear();
      _maknaLogoSelectedFiles.addAll(newFiles);
    });
  }

  void _submitKabinet(HimtikaKabinet? currentKabinet) {
    if (_formKeyKabinet.currentState!.validate()) {
      final List<Map<String, String>> nilaiKabinet = [];
      for (int i = 0; i < _nilaiTitleControllers.length; i++) {
        final title = _nilaiTitleControllers[i].text.trim();
        final desc = _nilaiDescControllers[i].text.trim();
        if (title.isNotEmpty || desc.isNotEmpty) {
          nilaiKabinet.add({
            'title': title,
            'description': desc,
          });
        }
      }

      final List<Map<String, String>> maknaLogo = [];
      for (int i = 0; i < _maknaLogoTitleControllers.length; i++) {
        final title = _maknaLogoTitleControllers[i].text.trim();
        final desc = _maknaLogoDescControllers[i].text.trim();
        final icon = i < _maknaLogoIconUrls.length ? _maknaLogoIconUrls[i] : '';
        if (title.isNotEmpty ||
            desc.isNotEmpty ||
            icon.isNotEmpty ||
            _maknaLogoSelectedFiles.containsKey(i)) {
          maknaLogo.add({
            'icon': icon,
            'title': title,
            'description': desc,
          });
        }
      }

      final kabinet = HimtikaKabinet(
        id: currentKabinet?.id ?? '',
        namaKabinet: _namaKabinetController.text.trim(),
        tagline: _taglineController.text.trim(),
        deskripsi: _deskripsiKabinetController.text.trim(),
        logoUrl: currentKabinet?.logoUrl,
        periode: _periodeController.text.trim(),
        isActive: currentKabinet?.isActive ?? true,
        nilaiKabinet: nilaiKabinet,
        maknaLogo: maknaLogo,
      );

      context.read<HimtikaManagementBloc>().add(
            UpdateKabinetEvent(
              kabinet: kabinet,
              logoFile: _selectedLogoFile,
              maknaLogoFiles: _maknaLogoSelectedFiles,
            ),
          );
    }
  }

  void _submitAbout(HimtikaAbout? currentAbout) {
    if (_formKeyAbout.currentState!.validate()) {
      final List<String> misiList = _misiControllers
          .map((c) => c.text.trim())
          .where((text) => text.isNotEmpty)
          .toList();

      final about = HimtikaAbout(
        id: currentAbout?.id ?? '',
        visi: _visiController.text.trim(),
        misi: misiList,
        sejarahText: _sejarahController.text.trim(),
      );

      context.read<HimtikaManagementBloc>().add(
            UpdateAboutEvent(about: about),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HimtikaManagementBloc, HimtikaManagementState>(
      listenWhen: (previous, current) =>
          previous.status != current.status ||
          previous.isSubmitting != current.isSubmitting ||
          previous.successMessage != current.successMessage ||
          previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        if (state.kabinet != null && _namaKabinetController.text.isEmpty) {
          _initDataFromState(state);
        }
      },
      child: BlocBuilder<HimtikaManagementBloc, HimtikaManagementState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SECTION 1: EDIT KABINET
                _buildCardSection(
                  title: 'Informasi Kabinet Aktif',
                  icon: Icons.account_balance,
                  child: Form(
                    key: _formKeyKabinet,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Logo Upload Row
                        Center(
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: _pickLogoImage,
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: const Color(0xFF0175C8),
                                      width: 2,
                                    ),
                                  ),
                                  child: _selectedLogoFile != null
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          child: Image.file(
                                            _selectedLogoFile!,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : (state.kabinet?.logoUrl != null &&
                                              state.kabinet!.logoUrl!.isNotEmpty
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                              child: Image.network(
                                                state.kabinet!.logoUrl!,
                                                fit: BoxFit.cover,
                                                errorBuilder:
                                                    (_, __, ___) => const Icon(
                                                        Icons.broken_image,
                                                        size: 40,
                                                        color: Colors.grey),
                                              ),
                                            )
                                          : const Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.cloud_upload,
                                                  size: 32,
                                                  color: Color(0xFF0175C8),
                                                ),
                                                SizedBox(height: 4),
                                                Text(
                                                  'Upload Logo',
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    color: Color(0xFF0175C8),
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            )),
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextButton.icon(
                                onPressed: _pickLogoImage,
                                icon: const Icon(Icons.photo_library, size: 16),
                                label: const Text('Pilih Logo Kabinet'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Nama Kabinet
                        TextFormField(
                          controller: _namaKabinetController,
                          decoration: InputDecoration(
                            labelText: 'Nama Kabinet *',
                            hintText: 'Contoh: Kabinet Abhinaya',
                            prefixIcon: const Icon(Icons.title),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value) => value == null || value.trim().isEmpty
                              ? 'Nama Kabinet tidak boleh kosong'
                              : null,
                        ),
                        const SizedBox(height: 14),

                        // Tagline
                        TextFormField(
                          controller: _taglineController,
                          decoration: InputDecoration(
                            labelText: 'Tagline',
                            hintText: 'Contoh: Sinergi dalam Karya',
                            prefixIcon: const Icon(Icons.format_quote),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Periode
                        TextFormField(
                          controller: _periodeController,
                          decoration: InputDecoration(
                            labelText: 'Periode *',
                            hintText: 'Contoh: 2025/2026',
                            prefixIcon: const Icon(Icons.calendar_today),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value) => value == null || value.trim().isEmpty
                              ? 'Periode tidak boleh kosong'
                              : null,
                        ),
                        const SizedBox(height: 14),

                        // Deskripsi Kabinet
                        TextFormField(
                          controller: _deskripsiKabinetController,
                          minLines: 2,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            alignLabelWithHint: true,
                            labelText: 'Deskripsi Kabinet',
                            hintText: 'Deskripsi singkat mengenai filosofi kabinet...',
                            prefixIcon: const Icon(Icons.description),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Dynamic Nilai Kabinet Section
                        const Divider(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Expanded(
                              child: Text(
                                'Nilai Kabinet',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E1E1E),
                                ),
                              ),
                            ),
                            TextButton.icon(
                              onPressed: _addNilaiField,
                              icon: const Icon(Icons.add_circle, size: 18),
                              label: const Text('Tambah Nilai'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        if (_nilaiTitleControllers.isEmpty)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: const Center(
                              child: Text(
                                'Belum ada nilai kabinet. Klik "Tambah Nilai" untuk menambahkan.',
                                style: TextStyle(color: Colors.black54, fontSize: 13),
                              ),
                            ),
                          )
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _nilaiTitleControllers.length,
                          itemBuilder: (context, index) {
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              color: const Color(0xFFE8F4FE),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: const BorderSide(color: Color(0xFF90CAF9)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Nilai #${index + 1}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF0175C8),
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete_outline,
                                            color: Colors.redAccent,
                                            size: 20,
                                          ),
                                          onPressed: () => _removeNilaiField(index),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    TextFormField(
                                      controller: _nilaiTitleControllers[index],
                                      decoration: InputDecoration(
                                        labelText: 'Judul Nilai',
                                        hintText: 'Contoh: Sinergi / Amanah',
                                        isDense: true,
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: const BorderSide(color: Color(0xFF0175C8), width: 1.5),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    TextFormField(
                                      controller: _nilaiDescControllers[index],
                                      minLines: 2,
                                      maxLines: null,
                                      keyboardType: TextInputType.multiline,
                                      decoration: InputDecoration(
                                        labelText: 'Deskripsi Nilai',
                                        hintText: 'Penjelasan mengenai nilai ini...',
                                        alignLabelWithHint: true,
                                        isDense: true,
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: const BorderSide(color: Color(0xFF0175C8), width: 1.5),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),

                        // Dynamic Makna Logo Section
                        const Divider(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Expanded(
                              child: Text(
                                'Makna Logo Kabinet',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E1E1E),
                                ),
                              ),
                            ),
                            TextButton.icon(
                              onPressed: _addMaknaLogoField,
                              icon: const Icon(Icons.add_circle, size: 18),
                              label: const Text('Tambah Makna Logo'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        if (_maknaLogoTitleControllers.isEmpty)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: const Center(
                              child: Text(
                                'Belum ada makna logo kabinet. Klik "Tambah Makna Logo" untuk menambahkan.',
                                style: TextStyle(color: Colors.black54, fontSize: 13),
                              ),
                            ),
                          )
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _maknaLogoTitleControllers.length,
                            itemBuilder: (context, index) {
                              final hasSelectedFile = _maknaLogoSelectedFiles.containsKey(index);
                              final currentUrl = index < _maknaLogoIconUrls.length ? _maknaLogoIconUrls[index] : '';

                              return Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                color: const Color(0xFFE8F4FE),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: const BorderSide(color: Color(0xFF90CAF9)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Makna Logo #${index + 1}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF0175C8),
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.delete_outline,
                                              color: Colors.redAccent,
                                              size: 20,
                                            ),
                                            onPressed: () => _removeMaknaLogoField(index),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),

                                      // Gambar Logo Picker & Preview
                                      Center(
                                        child: Column(
                                          children: [
                                            GestureDetector(
                                              onTap: () => _pickMaknaLogoImage(index),
                                              child: Container(
                                                width: 140,
                                                height: 80,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(10),
                                                  border: Border.all(color: const Color(0xFF90CAF9)),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(10),
                                                  child: hasSelectedFile
                                                      ? Image.file(
                                                          _maknaLogoSelectedFiles[index]!,
                                                          fit: BoxFit.contain,
                                                        )
                                                      : currentUrl.isNotEmpty
                                                          ? currentUrl.startsWith('http://') || currentUrl.startsWith('https://')
                                                              ? Image.network(
                                                                  currentUrl,
                                                                  fit: BoxFit.contain,
                                                                  errorBuilder: (_, __, ___) => const Icon(
                                                                    Icons.broken_image,
                                                                    color: Colors.grey,
                                                                    size: 36,
                                                                  ),
                                                                )
                                                              : Image.asset(
                                                                  currentUrl,
                                                                  fit: BoxFit.contain,
                                                                  errorBuilder: (_, __, ___) => const Icon(
                                                                    Icons.image_outlined,
                                                                    color: Colors.grey,
                                                                    size: 36,
                                                                  ),
                                                                )
                                                          : const Column(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                Icon(Icons.add_photo_alternate_outlined, color: Colors.grey, size: 28),
                                                                SizedBox(height: 4),
                                                                Text('Upload Gambar', style: TextStyle(color: Colors.grey, fontSize: 11)),
                                                              ],
                                                            ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            TextButton.icon(
                                              onPressed: () => _pickMaknaLogoImage(index),
                                              icon: const Icon(Icons.photo_library, size: 14),
                                              label: Text(
                                                hasSelectedFile || currentUrl.isNotEmpty ? 'Ganti Gambar' : 'Pilih Gambar',
                                                style: const TextStyle(fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 8),

                                       // Judul / Nama Elemen Logo
                                      TextFormField(
                                        controller: _maknaLogoTitleControllers[index],
                                        decoration: InputDecoration(
                                          labelText: 'Nama Elemen Logo',
                                          hintText: 'Contoh: Angsa / Bunga Teratai',
                                          isDense: true,
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                            borderSide: const BorderSide(color: Color(0xFF0175C8), width: 1.5),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),

                                      // Deskripsi Makna Logo
                                      TextFormField(
                                        controller: _maknaLogoDescControllers[index],
                                        minLines: 2,
                                        maxLines: null,
                                        keyboardType: TextInputType.multiline,
                                        decoration: InputDecoration(
                                          labelText: 'Deskripsi Makna Logo',
                                          hintText: 'Penjelasan filosofi elemen logo ini...',
                                          alignLabelWithHint: true,
                                          isDense: true,
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                            borderSide: const BorderSide(color: Color(0xFF0175C8), width: 1.5),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        const SizedBox(height: 20),

                        // Save Kabinet Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: state.isSubmitting
                                ? null
                                : () => _submitKabinet(state.kabinet),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0175C8),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            icon: state.isSubmitting
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.save),
                            label: Text(
                              state.isSubmitting
                                  ? 'Menyimpan...'
                                  : 'Simpan Informasi Kabinet',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // SECTION 2: EDIT ABOUT (VISI, MISI, SEJARAH)
                _buildCardSection(
                  title: 'Profil HIMTIKA (Visi, Misi & Sejarah)',
                  icon: Icons.article_outlined,
                  child: Form(
                    key: _formKeyAbout,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Visi
                        TextFormField(
                          controller: _visiController,
                          minLines: 2,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            alignLabelWithHint: true,
                            labelText: 'Visi HIMTIKA *',
                            hintText: 'Tuliskan visi HIMTIKA...',
                            prefixIcon: const Icon(Icons.visibility),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value) => value == null || value.trim().isEmpty
                              ? 'Visi tidak boleh kosong'
                              : null,
                        ),
                        const SizedBox(height: 20),

                        // Dynamic Misi Section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Misi HIMTIKA',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E1E1E),
                              ),
                            ),
                            TextButton.icon(
                              onPressed: _addMisiField,
                              icon: const Icon(Icons.add_circle, size: 18),
                              label: const Text('Tambah Misi'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _misiControllers.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 14,
                                    backgroundColor: const Color(0xFF0175C8),
                                    child: Text(
                                      '${index + 1}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _misiControllers[index],
                                      minLines: 1,
                                      maxLines: null,
                                      keyboardType: TextInputType.multiline,
                                      decoration: InputDecoration(
                                        hintText: 'Poin Misi ${index + 1}',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 10,
                                        ),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      color: Colors.redAccent,
                                    ),
                                    onPressed: () => _removeMisiField(index),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 16),

                        // Sejarah HIMTIKA
                        TextFormField(
                          controller: _sejarahController,
                          minLines: 4,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            alignLabelWithHint: true,
                            labelText: 'Sejarah HIMTIKA *',
                            hintText: 'Tuliskan sejarah berdirinya HIMTIKA...',
                            prefixIcon: const Icon(Icons.history_edu),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value) => value == null || value.trim().isEmpty
                              ? 'Sejarah tidak boleh kosong'
                              : null,
                        ),
                        const SizedBox(height: 20),

                        // Save About Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: state.isSubmitting
                                ? null
                                : () => _submitAbout(state.about),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0175C8),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            icon: state.isSubmitting
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.save),
                            label: Text(
                              state.isSubmitting
                                  ? 'Menyimpan...'
                                  : 'Simpan Profil HIMTIKA',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCardSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(icon, color: const Color(0xFF0175C8), size: 24),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    softWrap: true,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E1E),
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24, thickness: 1),
            child,
          ],
        ),
      ),
    );
  }
}
