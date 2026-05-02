// lib/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import '../models/app_data.dart';
import 'login_screen.dart';
import 'tambah_transaksi_screen.dart';
import 'rekening_screen.dart';
import 'recap_screen.dart';
import 'profil_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  int _bulanFilter = DateTime.now().month;
  int _tahunFilter = DateTime.now().year;

  void _onNavTap(int index) {
    if (index == 2) {
      // Tombol Tambah di tengah - buka halaman tambah transaksi
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const TambahTransaksiScreen()),
      ).then((_) => setState(() {}));
      return;
    }
    setState(() => _selectedIndex = index);
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Konfirmasi Logout'),
        content: const Text('Kamu yakin ingin keluar dari akun?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              AppData.logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildBeranda();
      case 1:
        return const RekeningScreen(isEmbedded: true);
      case 3:
        return RecapScreen(isEmbedded: true);
      case 4:
        return ProfilScreen(onLogout: _logout);
      default:
        return _buildBeranda();
    }
  }

  Widget _buildBeranda() {
    final pemasukan = AppData.totalPemasukan(_bulanFilter, _tahunFilter);
    final pengeluaran = AppData.totalPengeluaran(_bulanFilter, _tahunFilter);
    final sisa = pemasukan - pengeluaran;

    final transaksiFilter = AppData.daftarTransaksi
        .where((t) =>
            t.tanggal.month == _bulanFilter &&
            t.tanggal.year == _tahunFilter)
        .toList()
      ..sort((a, b) => b.tanggal.compareTo(a.tanggal));

    return SingleChildScrollView(
      child: Column(
        children: [
          // Header biru
          Container(
            padding: const EdgeInsets.fromLTRB(20, 52, 20, 28),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1A6BFF), Color(0xFF0A4FCC)],
              ),
              borderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(28)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Halo, 👋',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 14)),
                        Text(
                          AppData.namaUser,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: _logout,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.logout,
                                color: Colors.white, size: 16),
                            SizedBox(width: 4),
                            Text('Keluar',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text('Total Saldo',
                    style:
                        TextStyle(color: Colors.white70, fontSize: 13)),
                Text(
                  AppData.formatRupiah(AppData.totalSaldo),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                // Filter bulan
                GestureDetector(
                  onTap: _pilihBulan,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.calendar_month,
                            color: Colors.white, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          '${AppData.namaBulan(_bulanFilter)} $_tahunFilter',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.keyboard_arrow_down,
                            color: Colors.white, size: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Kartu ringkasan
                Row(
                  children: [
                    Expanded(
                      child: _buildRingkasanCard(
                        'Pemasukan',
                        AppData.formatRupiah(pemasukan),
                        Icons.arrow_downward_rounded,
                        const Color(0xFF00C48C),
                        const Color(0xFFE6FFF7),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildRingkasanCard(
                        'Pengeluaran',
                        AppData.formatRupiah(pengeluaran),
                        Icons.arrow_upward_rounded,
                        Colors.redAccent,
                        const Color(0xFFFFEEEE),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F5FF),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: const Color(0xFF1A6BFF).withOpacity(0.2)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Sisa Bulan Ini',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14)),
                      Text(
                        AppData.formatRupiah(sisa),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: sisa >= 0
                              ? const Color(0xFF1A6BFF)
                              : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Transaksi terkini
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Transaksi Terkini',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    GestureDetector(
                      onTap: () => setState(() => _selectedIndex = 3),
                      child: const Text('Lihat Semua',
                          style: TextStyle(
                              color: Color(0xFF1A6BFF),
                              fontWeight: FontWeight.w600,
                              fontSize: 13)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                if (transaksiFilter.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Icon(Icons.receipt_long_outlined,
                              size: 48, color: Colors.grey.shade300),
                          const SizedBox(height: 12),
                          const Text('Belum ada transaksi bulan ini',
                              style: TextStyle(color: Colors.grey)),
                          const SizedBox(height: 8),
                          const Text('Tap tombol + untuk menambahkan',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ),
                  )
                else
                  ...transaksiFilter
                      .take(5)
                      .map((t) => _buildTransaksiItem(t)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRingkasanCard(
      String judul, String nilai, IconData icon, Color warna, Color bg) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: warna.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: warna, size: 16),
              ),
              const SizedBox(width: 8),
              Text(judul,
                  style: TextStyle(
                      color: Colors.grey.shade600, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          Text(nilai,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: warna)),
        ],
      ),
    );
  }

  Widget _buildTransaksiItem(TransaksiModel t) {
    final isPemasukan = t.tipe == 'pemasukan';
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: isPemasukan
                  ? const Color(0xFFE6FFF7)
                  : const Color(0xFFFFEEEE),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isPemasukan
                  ? Icons.arrow_downward_rounded
                  : Icons.arrow_upward_rounded,
              color: isPemasukan
                  ? const Color(0xFF00C48C)
                  : Colors.redAccent,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.nama,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14)),
                Text(
                  '${t.kategori} • ${AppData.formatTanggal(t.tanggal)}',
                  style: TextStyle(
                      color: Colors.grey.shade500, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            '${isPemasukan ? '+' : '-'}${AppData.formatRupiah(t.jumlah)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isPemasukan
                  ? const Color(0xFF00C48C)
                  : Colors.redAccent,
            ),
          ),
        ],
      ),
    );
  }

  void _pilihBulan() {
    int tempBulan = _bulanFilter;
    int tempTahun = _tahunFilter;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Pilih Bulan & Tahun',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () =>
                            setModalState(() => tempTahun--),
                        icon: const Icon(Icons.chevron_left),
                      ),
                      Text('$tempTahun',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      IconButton(
                        onPressed: () =>
                            setModalState(() => tempTahun++),
                        icon: const Icon(Icons.chevron_right),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(12, (i) {
                      final b = i + 1;
                      final selected = b == tempBulan;
                      return GestureDetector(
                        onTap: () =>
                            setModalState(() => tempBulan = b),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: selected
                                ? const Color(0xFF1A6BFF)
                                : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            AppData.namaBulan(b).substring(0, 3),
                            style: TextStyle(
                              color: selected
                                  ? Colors.white
                                  : Colors.black87,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _bulanFilter = tempBulan;
                          _tahunFilter = tempTahun;
                        });
                        Navigator.pop(ctx);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A6BFF),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Terapkan'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home_rounded, 'Beranda'),
              _buildNavItem(1, Icons.account_balance_wallet_rounded, 'Rekening'),
              // Tombol Tambah di tengah, lebih besar
              GestureDetector(
                onTap: () => _onNavTap(2),
                child: Container(
                  width: 58,
                  height: 58,
                  margin: const EdgeInsets.only(bottom: 6),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1A6BFF), Color(0xFF0A4FCC)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1A6BFF).withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 30),
                ),
              ),
              _buildNavItem(3, Icons.bar_chart_rounded, 'Rekap'),
              _buildNavItem(4, Icons.person_rounded, 'Profil'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    // Index 2 is the add button, skip
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onNavTap(index),
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? const Color(0xFF1A6BFF)
                  : Colors.grey.shade400,
              size: 24,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? const Color(0xFF1A6BFF)
                    : Colors.grey.shade400,
                fontSize: 10,
                fontWeight: isSelected
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}