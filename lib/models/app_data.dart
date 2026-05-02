// lib/models/app_data.dart
// SiMu - Sistem Keuangan Mahasiswa
// Kelompok 6 - Universitas Negeri Gorontalo

class TransaksiModel {
  String id;
  String nama;
  double jumlah;
  String tipe; // 'pemasukan' atau 'pengeluaran'
  String kategori;
  String rekening;
  String catatan;
  DateTime tanggal;

  TransaksiModel({
    required this.id,
    required this.nama,
    required this.jumlah,
    required this.tipe,
    required this.kategori,
    required this.rekening,
    this.catatan = '',
    required this.tanggal,
  });
}

class RekeningModel {
  String id;
  String namaBank;
  String nomorRekening;
  double saldo;
  String icon;

  RekeningModel({
    required this.id,
    required this.namaBank,
    required this.nomorRekening,
    required this.saldo,
    required this.icon,
  });
}

class UserModel {
  String nama;
  String email;
  String password;

  UserModel({
    required this.nama,
    required this.email,
    required this.password,
  });
}

class AppData {
  // Auth
  static String namaUser = '';
  static String emailUser = '';
  static bool isLoggedIn = false;

  // Data global
  static List<TransaksiModel> daftarTransaksi = [];
  static List<RekeningModel> daftarRekening = [];
  static List<UserModel> daftarUser = [
    UserModel(nama: 'Admin Demo', email: 'demo@simu.com', password: '123456'),
  ];

  // Default rekening
  static void initDefaultData() {
    if (daftarRekening.isEmpty) {
      daftarRekening = [
        RekeningModel(
          id: 'r1',
          namaBank: 'BRI',
          nomorRekening: '1234-5678-9012',
          saldo: 500000,
          icon: '🏦',
        ),
        RekeningModel(
          id: 'r2',
          namaBank: 'Dana',
          nomorRekening: '0812-3456-7890',
          saldo: 150000,
          icon: '📱',
        ),
      ];
    }
  }

  // Hitung total saldo
  static double get totalSaldo {
    return daftarRekening.fold(0, (sum, r) => sum + r.saldo);
  }

  // Hitung pemasukan bulan tertentu
  static double totalPemasukan(int bulan, int tahun) {
    return daftarTransaksi
        .where((t) =>
            t.tipe == 'pemasukan' &&
            t.tanggal.month == bulan &&
            t.tanggal.year == tahun)
        .fold(0, (sum, t) => sum + t.jumlah);
  }

  // Hitung pengeluaran bulan tertentu
  static double totalPengeluaran(int bulan, int tahun) {
    return daftarTransaksi
        .where((t) =>
            t.tipe == 'pengeluaran' &&
            t.tanggal.month == bulan &&
            t.tanggal.year == tahun)
        .fold(0, (sum, t) => sum + t.jumlah);
  }

  // Format rupiah
  static String formatRupiah(double angka) {
    String str = angka.toStringAsFixed(0);
    String result = '';
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) result = '.' + result;
      result = str[i] + result;
      count++;
    }
    return 'Rp $result';
  }

  // Format tanggal
  static String formatTanggal(DateTime dt) {
    return '${dt.day} ${namaBulan(dt.month)} ${dt.year}';
  }

  // Nama bulan
  static String namaBulan(int bulan) {
    const bulanList = [
      '', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return bulanList[bulan];
  }

  // Kategori pengeluaran
  static List<String> kategoriPengeluaran = [
    'Makan', 'Transport', 'Belanja', 'Hiburan',
    'Kesehatan', 'Pendidikan', 'Tagihan', 'Lainnya'
  ];

  // Kategori pemasukan
  static List<String> kategoriPemasukan = [
    'Beasiswa', 'Kiriman Ortu', 'Kerja Part-time', 'Freelance', 'Lainnya'
  ];

  // Logout
  static void logout() {
    namaUser = '';
    emailUser = '';
    isLoggedIn = false;
  }
}