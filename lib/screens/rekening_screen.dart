// lib/screens/rekening_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/app_data.dart';

class RekeningScreen extends StatefulWidget {
  final bool isEmbedded;
  const RekeningScreen({super.key, this.isEmbedded = false});

  @override
  State<RekeningScreen> createState() => _RekeningScreenState();
}

class _RekeningScreenState extends State<RekeningScreen> {
  void _tambahRekening() {
    final namaCtrl = TextEditingController();
    final nomorCtrl = TextEditingController();
    final saldoCtrl = TextEditingController();
    String iconPilih = '🏦';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModal) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Tambah Rekening Baru',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  // Pilih icon
                  Wrap(
                    spacing: 10,
                    children: ['🏦', '📱', '💳', '🏧', '💰'].map((ic) {
                      return GestureDetector(
                        onTap: () => setModal(() => iconPilih = ic),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: iconPilih == ic
                                ? const Color(0xFF1A6BFF).withOpacity(0.1)
                                : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: iconPilih == ic
                                  ? const Color(0xFF1A6BFF)
                                  : Colors.transparent,
                            ),
                          ),
                          child: Text(ic, style: const TextStyle(fontSize: 22)),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 14),
                  _modalField(namaCtrl, 'Nama Bank / E-Wallet',
                      Icons.account_balance, TextInputType.text),
                  const SizedBox(height: 10),
                  _modalField(nomorCtrl, 'Nomor Rekening',
                      Icons.numbers, TextInputType.number),
                  const SizedBox(height: 10),
                  _modalField(saldoCtrl, 'Saldo Awal (Rp)',
                      Icons.monetization_on_outlined, TextInputType.number),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (namaCtrl.text.trim().isEmpty ||
                            nomorCtrl.text.trim().isEmpty) {
                          return;
                        }
                        final saldo = double.tryParse(saldoCtrl.text) ?? 0;
                        AppData.daftarRekening.add(RekeningModel(
                          id: DateTime.now()
                              .millisecondsSinceEpoch
                              .toString(),
                          namaBank: namaCtrl.text.trim(),
                          nomorRekening: nomorCtrl.text.trim(),
                          saldo: saldo,
                          icon: iconPilih,
                        ));
                        setState(() {});
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Rekening berhasil ditambahkan!'),
                            backgroundColor: const Color(0xFF00C48C),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A6BFF),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Simpan'),
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

  void _hapusRekening(RekeningModel rek) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Rekening'),
        content: Text(
            'Hapus rekening ${rek.namaBank}? Transaksi yang terkait tidak akan terhapus.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              AppData.daftarRekening.removeWhere((r) => r.id == rek.id);
              setState(() {});
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Rekening dihapus'),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final body = SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Total saldo
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1A6BFF), Color(0xFF0A4FCC)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Total Saldo',
                    style: TextStyle(color: Colors.white70, fontSize: 13)),
                const SizedBox(height: 6),
                Text(
                  AppData.formatRupiah(AppData.totalSaldo),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  '${AppData.daftarRekening.length} rekening aktif',
                  style: const TextStyle(
                      color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Daftar Rekening',
                  style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              GestureDetector(
                onTap: _tambahRekening,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A6BFF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.add, color: Colors.white, size: 16),
                      SizedBox(width: 4),
                      Text('Tambah',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (AppData.daftarRekening.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(Icons.account_balance_wallet_outlined,
                        size: 48, color: Colors.grey.shade300),
                    const SizedBox(height: 12),
                    const Text('Belum ada rekening',
                        style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 8),
                    const Text('Tap tombol Tambah untuk menambahkan',
                        style:
                            TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
            )
          else
            ...AppData.daftarRekening.map((r) => _buildRekeningCard(r)),
        ],
      ),
    );

    if (widget.isEmbedded) {
      return Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 52, 20, 20),
            color: const Color(0xFF1A6BFF),
            child: const Text('Rekening Saya',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
          ),
          Expanded(child: body),
        ],
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A6BFF),
        foregroundColor: Colors.white,
        title: const Text('Rekening'),
        elevation: 0,
      ),
      body: body,
    );
  }

  Widget _buildRekeningCard(RekeningModel rek) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F5FF),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(rek.icon, style: const TextStyle(fontSize: 24)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(rek.namaBank,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15)),
                Text(rek.nomorRekening,
                    style: TextStyle(
                        color: Colors.grey.shade500, fontSize: 12)),
                const SizedBox(height: 4),
                Text(AppData.formatRupiah(rek.saldo),
                    style: const TextStyle(
                        color: Color(0xFF1A6BFF),
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete_outline,
                color: Colors.red.shade300),
            onPressed: () => _hapusRekening(rek),
          ),
        ],
      ),
    );
  }

  Widget _modalField(TextEditingController ctrl, String hint,
      IconData icon, TextInputType type) {
    return TextField(
      controller: ctrl,
      keyboardType: type,
      inputFormatters: type == TextInputType.number
          ? [FilteringTextInputFormatter.digitsOnly]
          : null,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFF1A6BFF)),
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF1A6BFF), width: 2),
        ),
      ),
    );
  }
}