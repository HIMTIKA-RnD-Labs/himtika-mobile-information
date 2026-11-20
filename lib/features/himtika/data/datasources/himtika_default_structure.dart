class DefaultDivision {
  final String name;
  final String defaultCardAsset;
  final int urutan;

  const DefaultDivision({
    required this.name,
    required this.defaultCardAsset,
    required this.urutan,
  });
}

class DefaultMember {
  final String division;
  final String? department;
  final String position;
  final String name;
  final String defaultAsset;
  final int urutan;

  const DefaultMember({
    required this.division,
    this.department,
    required this.position,
    required this.name,
    required this.defaultAsset,
    required this.urutan,
  });
}

class HimtikaDefaultStructure {
  static const List<DefaultDivision> defaultDivisions = [
    DefaultDivision(
      name: 'Steering Committee',
      defaultCardAsset: 'src/features/himtika/divisi/sc/sc.png',
      urutan: 0,
    ),
    DefaultDivision(
      name: 'Divisi Internal',
      defaultCardAsset: 'src/features/himtika/divisi/internal/internal.png',
      urutan: 1,
    ),
    DefaultDivision(
      name: 'Divisi RnD',
      defaultCardAsset: 'src/features/himtika/divisi/rnd/rnd.png',
      urutan: 2,
    ),
    DefaultDivision(
      name: 'Divisi Relasi',
      defaultCardAsset: 'src/features/himtika/divisi/relasi/relasi.png',
      urutan: 3,
    ),
    DefaultDivision(
      name: 'Divisi Edukasi',
      defaultCardAsset: 'src/features/himtika/divisi/edukasi/edukasi.png',
      urutan: 4,
    ),
    DefaultDivision(
      name: 'Divisi Infokom',
      defaultCardAsset: 'src/features/himtika/divisi/infokom/infokom.png',
      urutan: 5,
    ),
  ];

  static const List<String> divisionNames = [
    'Steering Committee',
    'Divisi Internal',
    'Divisi RnD',
    'Divisi Relasi',
    'Divisi Edukasi',
    'Divisi Infokom',
  ];

  static const List<DefaultMember> allMembers = [
    // --- Steering Committee ---
    DefaultMember(
      division: 'Steering Committee',
      department: 'Steering Committee',
      position: 'Ketua Himpunan',
      name: 'Iqbal Umar Kadafi',
      defaultAsset: 'src/features/himtika/divisi/sc/kahim.png',
      urutan: 1,
    ),
    DefaultMember(
      division: 'Steering Committee',
      department: 'Steering Committee',
      position: 'Wakil Ketua Himpunan',
      name: 'Wanda Lionita Leilmutasya',
      defaultAsset: 'src/features/himtika/divisi/sc/wahim.png',
      urutan: 2,
    ),
    DefaultMember(
      division: 'Steering Committee',
      department: 'Steering Committee',
      position: 'Sekretaris Umum',
      name: 'Erizka Nia Ramadhani',
      defaultAsset: 'src/features/himtika/divisi/sc/sekum.png',
      urutan: 3,
    ),
    DefaultMember(
      division: 'Steering Committee',
      department: 'Steering Committee',
      position: 'Wakil Sekretaris Umum',
      name: 'Alia Hamzah',
      defaultAsset: 'src/features/himtika/divisi/sc/wasekum.png',
      urutan: 4,
    ),
    DefaultMember(
      division: 'Steering Committee',
      department: 'Steering Committee',
      position: 'Bendahara Umum',
      name: 'Putra Raka Pratama',
      defaultAsset: 'src/features/himtika/divisi/sc/bendum.png',
      urutan: 5,
    ),
    DefaultMember(
      division: 'Steering Committee',
      department: 'Steering Committee',
      position: 'Wakil Bendahara Umum',
      name: 'Anisa Diyah Ayu Lestari',
      defaultAsset: 'src/features/himtika/divisi/sc/wabendum.png',
      urutan: 6,
    ),
    DefaultMember(
      division: 'Steering Committee',
      department: 'Badan Pengurus Harian',
      position: 'Ketua Divisi Internal',
      name: 'Indira Ayu Anggraeni',
      defaultAsset: 'src/features/himtika/divisi/internal/ketua.png',
      urutan: 7,
    ),
    DefaultMember(
      division: 'Steering Committee',
      department: 'Badan Pengurus Harian',
      position: 'Ketua Divisi RnD',
      name: 'Naufal Syafiq Fadillah',
      defaultAsset: 'src/features/himtika/divisi/rnd/ketua.png',
      urutan: 8,
    ),
    DefaultMember(
      division: 'Steering Committee',
      department: 'Badan Pengurus Harian',
      position: 'Ketua Divisi Relasi',
      name: 'Haliza Adzikia Sukarno',
      defaultAsset: 'src/features/himtika/divisi/relasi/ketua.png',
      urutan: 9,
    ),
    DefaultMember(
      division: 'Steering Committee',
      department: 'Badan Pengurus Harian',
      position: 'Ketua Divisi Edukasi',
      name: 'Ahmad Zulkarnaen',
      defaultAsset: 'src/features/himtika/divisi/edukasi/ketua.png',
      urutan: 10,
    ),
    DefaultMember(
      division: 'Steering Committee',
      department: 'Badan Pengurus Harian',
      position: 'Ketua Divisi Infokom',
      name: 'Wahyu Widi Widayat',
      defaultAsset: 'src/features/himtika/divisi/infokom/ketua.png',
      urutan: 11,
    ),

    // --- Divisi Internal ---
    DefaultMember(
      division: 'Divisi Internal',
      department: null,
      position: 'Ketua Divisi Internal',
      name: 'Indira Ayu Anggraeni',
      defaultAsset: 'src/features/himtika/divisi/internal/ketua.png',
      urutan: 1,
    ),
    DefaultMember(
      division: 'Divisi Internal',
      department: 'Dept. Human Resource Development',
      position: 'Ketua Dept. HRD',
      name: 'Anya Sabrina Narulita',
      defaultAsset: 'src/features/himtika/divisi/internal/kadepHRD.png',
      urutan: 2,
    ),
    DefaultMember(
      division: 'Divisi Internal',
      department: 'Dept. Human Resource Development',
      position: 'Anggota Dept. HRD',
      name: 'Indyra Putri Pratama',
      defaultAsset: 'src/features/himtika/divisi/internal/indira.png',
      urutan: 3,
    ),
    DefaultMember(
      division: 'Divisi Internal',
      department: 'Dept. Human Resource Development',
      position: 'Anggota Dept. HRD',
      name: 'Andhika Subagja',
      defaultAsset: 'src/features/himtika/divisi/internal/bagja.png',
      urutan: 4,
    ),
    DefaultMember(
      division: 'Divisi Internal',
      department: 'Dept. Human Resource Development',
      position: 'Anggota Dept. HRD',
      name: 'Ambar Triyasmin',
      defaultAsset: 'src/features/himtika/divisi/internal/yasmin.png',
      urutan: 5,
    ),
    DefaultMember(
      division: 'Divisi Internal',
      department: 'Dept. HIMTIKA Care',
      position: 'Ketua Dept. HC',
      name: 'Nazla Arina Nurfia Sofa',
      defaultAsset: 'src/features/himtika/divisi/internal/kadepHC.png',
      urutan: 6,
    ),
    DefaultMember(
      division: 'Divisi Internal',
      department: 'Dept. HIMTIKA Care',
      position: 'Anggota Dept. HC',
      name: 'Andhika Sukma Jiwatama',
      defaultAsset: 'src/features/himtika/divisi/internal/sukma.png',
      urutan: 7,
    ),
    DefaultMember(
      division: 'Divisi Internal',
      department: 'Dept. HIMTIKA Care',
      position: 'Anggota Dept. HC',
      name: 'Hanna Fadillah Septiana',
      defaultAsset: 'src/features/himtika/divisi/internal/hanna.png',
      urutan: 8,
    ),
    DefaultMember(
      division: 'Divisi Internal',
      department: 'Dept. HIMTIKA Care',
      position: 'Anggota Dept. HC',
      name: 'Imas Anisa',
      defaultAsset: 'src/features/himtika/divisi/internal/sasa.png',
      urutan: 9,
    ),

    // --- Divisi RnD ---
    DefaultMember(
      division: 'Divisi RnD',
      department: null,
      position: 'Ketua Divisi RnD',
      name: 'Naufal Syafiq Fadillah',
      defaultAsset: 'src/features/himtika/divisi/rnd/ketua.png',
      urutan: 1,
    ),
    DefaultMember(
      division: 'Divisi RnD',
      department: 'Dept. Product Development',
      position: 'Ketua Dept. Product',
      name: 'Ferdi Yansah',
      defaultAsset: 'src/features/himtika/divisi/rnd/kadepProduct.png',
      urutan: 2,
    ),
    DefaultMember(
      division: 'Divisi RnD',
      department: 'Dept. Product Development',
      position: 'Anggota Dept. Product',
      name: 'Geral Tritama Wahyuady',
      defaultAsset: 'src/features/himtika/divisi/rnd/geral.png',
      urutan: 3,
    ),
    DefaultMember(
      division: 'Divisi RnD',
      department: 'Dept. Product Development',
      position: 'Anggota Dept. Product',
      name: 'Raika Maulana Dwi Putra',
      defaultAsset: 'src/features/himtika/divisi/rnd/raika.png',
      urutan: 4,
    ),
    DefaultMember(
      division: 'Divisi RnD',
      department: 'Dept. Product Development',
      position: 'Anggota Dept. Product',
      name: 'Muhammad Jibran Tariq',
      defaultAsset: 'src/features/himtika/divisi/rnd/jibran.png',
      urutan: 5,
    ),
    DefaultMember(
      division: 'Divisi RnD',
      department: 'Dept. Riset Development',
      position: 'Ketua Dept. Riset',
      name: 'Mahesa Muhamad Nabil',
      defaultAsset: 'src/features/himtika/divisi/rnd/kadepRiset.png',
      urutan: 6,
    ),
    DefaultMember(
      division: 'Divisi RnD',
      department: 'Dept. Riset Development',
      position: 'Anggota Dept. Riset',
      name: 'Muhammad Rizky Dermawan',
      defaultAsset: 'src/features/himtika/divisi/rnd/menrey.png',
      urutan: 7,
    ),

    // --- Divisi Relasi ---
    DefaultMember(
      division: 'Divisi Relasi',
      department: null,
      position: 'Ketua Divisi Relasi',
      name: 'Haliza Adzikia Sukarno',
      defaultAsset: 'src/features/himtika/divisi/relasi/ketua.png',
      urutan: 1,
    ),
    DefaultMember(
      division: 'Divisi Relasi',
      department: 'Dept. Public & Marketing',
      position: 'Ketua Dept. PM',
      name: 'Halvina Farras Savitri',
      defaultAsset: 'src/features/himtika/divisi/relasi/kadepPM.png',
      urutan: 2,
    ),
    DefaultMember(
      division: 'Divisi Relasi',
      department: 'Dept. Public & Marketing',
      position: 'Anggota Dept. PM',
      name: 'Martin Ekaputra A.',
      defaultAsset: 'src/features/himtika/divisi/relasi/martin.png',
      urutan: 3,
    ),
    DefaultMember(
      division: 'Divisi Relasi',
      department: 'Dept. Public & Marketing',
      position: 'Anggota Dept. PM',
      name: 'Rois Alif Pradipa',
      defaultAsset: 'src/features/himtika/divisi/relasi/rois.png',
      urutan: 4,
    ),
    DefaultMember(
      division: 'Divisi Relasi',
      department: 'Dept. Public Relation',
      position: 'Ketua Dept. PR',
      name: 'M. Akmal Fauzan Nur R.',
      defaultAsset: 'src/features/himtika/divisi/relasi/kadepPR.png',
      urutan: 5,
    ),
    DefaultMember(
      division: 'Divisi Relasi',
      department: 'Dept. Public Relation',
      position: 'Anggota Dept. PR',
      name: 'Helmi Zain Fakhruriza D.',
      defaultAsset: 'src/features/himtika/divisi/relasi/zain.png',
      urutan: 6,
    ),
    DefaultMember(
      division: 'Divisi Relasi',
      department: 'Dept. Public Relation',
      position: 'Anggota Dept. PR',
      name: 'Dewa Putu Atma D.',
      defaultAsset: 'src/features/himtika/divisi/relasi/dewa.png',
      urutan: 7,
    ),
    DefaultMember(
      division: 'Divisi Relasi',
      department: 'Dept. Public Relation',
      position: 'Anggota Dept. PR',
      name: 'Refi Abdillah',
      defaultAsset: 'src/features/himtika/divisi/relasi/refi.png',
      urutan: 8,
    ),

    // --- Divisi Edukasi ---
    DefaultMember(
      division: 'Divisi Edukasi',
      department: null,
      position: 'Ketua Divisi Edukasi',
      name: 'Ahmad Zulkarnaen',
      defaultAsset: 'src/features/himtika/divisi/edukasi/ketua.png',
      urutan: 1,
    ),
    DefaultMember(
      division: 'Divisi Edukasi',
      department: 'Dept. College Education',
      position: 'Ketua Dept. College Edu',
      name: 'Zakki Khairul Abdulaziz',
      defaultAsset: 'src/features/himtika/divisi/edukasi/kadepCollege.png',
      urutan: 2,
    ),
    DefaultMember(
      division: 'Divisi Edukasi',
      department: 'Dept. College Education',
      position: 'Anggota Dept. College Edu',
      name: 'Rifqy Kurniawan Fattahillah',
      defaultAsset: 'src/features/himtika/divisi/edukasi/rifqy.png',
      urutan: 3,
    ),
    DefaultMember(
      division: 'Divisi Edukasi',
      department: 'Dept. College Education',
      position: 'Anggota Dept. College Edu',
      name: 'Shidqy Khairu Dwijaya',
      defaultAsset: 'src/features/himtika/divisi/edukasi/shidqy.png',
      urutan: 4,
    ),
    DefaultMember(
      division: 'Divisi Edukasi',
      department: 'Dept. College Education',
      position: 'Anggota Dept. College Edu',
      name: 'Nadrina Pratama Hilyawanti',
      defaultAsset: 'src/features/himtika/divisi/edukasi/nadrina.png',
      urutan: 5,
    ),
    DefaultMember(
      division: 'Divisi Edukasi',
      department: 'Dept. Skill Education',
      position: 'Ketua Dept. Skill Edu',
      name: 'Inong Muliya Zahra',
      defaultAsset: 'src/features/himtika/divisi/edukasi/kadepSkill.png',
      urutan: 6,
    ),
    DefaultMember(
      division: 'Divisi Edukasi',
      department: 'Dept. Skill Education',
      position: 'Anggota Dept. Skill Edu',
      name: 'Anggun Permata Sari',
      defaultAsset: 'src/features/himtika/divisi/edukasi/anggun.png',
      urutan: 7,
    ),
    DefaultMember(
      division: 'Divisi Edukasi',
      department: 'Dept. Skill Education',
      position: 'Anggota Dept. Skill Edu',
      name: 'Nugraha Adani',
      defaultAsset: 'src/features/himtika/divisi/edukasi/nugi.png',
      urutan: 8,
    ),
    DefaultMember(
      division: 'Divisi Edukasi',
      department: 'Dept. Skill Education',
      position: 'Anggota Dept. Skill Edu',
      name: 'Bahrul Alakin',
      defaultAsset: 'src/features/himtika/divisi/edukasi/bahrul.png',
      urutan: 9,
    ),
    DefaultMember(
      division: 'Divisi Edukasi',
      department: 'Dept. Skill Education',
      position: 'Anggota Dept. Skill Edu',
      name: 'Ori Suhana',
      defaultAsset: 'src/features/himtika/divisi/edukasi/ori.png',
      urutan: 10,
    ),

    // --- Divisi Infokom ---
    DefaultMember(
      division: 'Divisi Infokom',
      department: null,
      position: 'Ketua Divisi Infokom',
      name: 'Wahyu Widi Widayat',
      defaultAsset: 'src/features/himtika/divisi/infokom/ketua.png',
      urutan: 1,
    ),
    DefaultMember(
      division: 'Divisi Infokom',
      department: 'Dept. Media Creative',
      position: 'Ketua Dept. MC',
      name: 'Nafhan Haqiqi',
      defaultAsset: 'src/features/himtika/divisi/infokom/kadepMC.png',
      urutan: 2,
    ),
    DefaultMember(
      division: 'Divisi Infokom',
      department: 'Dept. Media Creative',
      position: 'Anggota Dept. MC',
      name: 'Farel Darmawan',
      defaultAsset: 'src/features/himtika/divisi/infokom/farel.png',
      urutan: 3,
    ),
    DefaultMember(
      division: 'Divisi Infokom',
      department: 'Dept. Media Creative',
      position: 'Anggota Dept. MC',
      name: 'Syahid Ahmad Yasin',
      defaultAsset: 'src/features/himtika/divisi/infokom/syahid.png',
      urutan: 4,
    ),
    DefaultMember(
      division: 'Divisi Infokom',
      department: 'Dept. Media Creative',
      position: 'Anggota Dept. MC',
      name: 'M. Zidane Akbari',
      defaultAsset: 'src/features/himtika/divisi/infokom/zidane.png',
      urutan: 5,
    ),
    DefaultMember(
      division: 'Divisi Infokom',
      department: 'Dept. Media Creative',
      position: 'Anggota Dept. MC',
      name: 'Rizki Isma Ramadhani',
      defaultAsset: 'src/features/himtika/divisi/infokom/isma.png',
      urutan: 6,
    ),
    DefaultMember(
      division: 'Divisi Infokom',
      department: 'Dept. Media Creative',
      position: 'Anggota Dept. MC',
      name: 'Dwiyandra Raysha P. S.',
      defaultAsset: 'src/features/himtika/divisi/infokom/raysha.png',
      urutan: 7,
    ),
    DefaultMember(
      division: 'Divisi Infokom',
      department: 'Dept. Media Information',
      position: 'Ketua Dept. MI',
      name: 'Raihan Febriahdi',
      defaultAsset: 'src/features/himtika/divisi/infokom/kadepMI.png',
      urutan: 8,
    ),
    DefaultMember(
      division: 'Divisi Infokom',
      department: 'Dept. Media Information',
      position: 'Anggota Dept. MI',
      name: 'Atika Sari Ramadhani',
      defaultAsset: 'src/features/himtika/divisi/infokom/tika.png',
      urutan: 9,
    ),
    DefaultMember(
      division: 'Divisi Infokom',
      department: 'Dept. Media Information',
      position: 'Anggota Dept. MI',
      name: 'Arsya Apricia Purnomo',
      defaultAsset: 'src/features/himtika/divisi/infokom/arsya.png',
      urutan: 10,
    ),
  ];

  static List<DefaultMember> getMembersByDivision(String divisionName) {
    final cleanTarget = divisionName.toLowerCase().replaceAll('divisi ', '').trim();
    return allMembers.where((m) {
      final cleanDiv = m.division.toLowerCase().replaceAll('divisi ', '').trim();
      return cleanDiv == cleanTarget;
    }).toList();
  }
}
