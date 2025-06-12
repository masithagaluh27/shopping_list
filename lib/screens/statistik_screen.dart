import 'package:flutter/material.dart';
import 'package:shopping_list/database/db_helper.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StatistikScreen extends StatefulWidget {
  final int userId; // Add userId to the constructor
  const StatistikScreen({super.key, required this.userId});

  // ID route untuk navigasi ke halaman statistik
  static const String id = '/statistik';

  @override
  State<StatistikScreen> createState() => _StatistikScreenState();
}

class _StatistikScreenState extends State<StatistikScreen> {
  // List untuk menyimpan semua item yang diambil dari database
  List<Map<String, dynamic>> items = [];

  // dipanggil pertama kali ketika halaman dibuka
  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  // Fungsi async untuk mengambil data dari database dan menyimpannya ke dalam list items
  Future<void> _loadItems() async {
    // Changed: Now uses getItemsByUser to fetch items specific to the logged-in user
    final data = await DBHELPER13.getItemsByUser(widget.userId);
    setState(() {
      items = data; // Set data ke dalam state agar UI diperbarui
    });
  }

  @override
  Widget build(BuildContext context) {
    // Konversi list items menjadi list chartData khusus untuk chart
    final chartData =
        items
            .map(
              (item) =>
                  GrafikData(item['name'] as String, item['quantity'] as int),
            )
            .toList();

    return Scaffold(
      appBar: AppBar(
        // u/ menghapus panah kiri dg paksa!!!
        automaticallyImplyLeading: false,
        title: const Text('Statistik Belanja'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadItems, // Tombol refresh untuk memuat ulang data
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Statistik Jumlah Produk',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 20),

            // Jika ada data untuk ditampilkan, tampilkan grafik
            if (chartData.isNotEmpty)
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection:
                      Axis.horizontal, // scrooll horizontal agar semua data terlihat
                  child: SizedBox(
                    // u/ Ukuran lebar agar jumlah item tidak sempit
                    width: items.length * 100.0,
                    child: SfCartesianChart(
                      // pakai itu karena kompatibel dg sumbu x dan y

                      //primary = sumbu utama
                      primaryXAxis: CategoryAxis(), // Sumbu X u/ nama produk
                      primaryYAxis: NumericAxis(
                        title: AxisTitle(text: 'Quantity'), // Label sumbu Y
                        interval: 10, // Jarak antar nilai
                        minimum: 0, // Nilai minimum sumbu Y
                      ),
                      tooltipBehavior: TooltipBehavior(
                        enable: true,
                      ), // Aktifkan tooltip & behavior utk
                      // Tipe grafik yang digunakan adalah LineSeries (garis)
                      series: <LineSeries<GrafikData, String>>[
                        LineSeries<GrafikData, String>(
                          dataSource: chartData, // Data yang akan ditampilkan
                          //u/ data ap yg akn digunakan
                          xValueMapper:
                              (GrafikData data, _) =>
                                  data.name, // Sumbu X: nama produk
                          yValueMapper:
                              (GrafikData data, _) =>
                                  data.quantity, // Sumbu Y: jumlah
                          dataLabelSettings: const DataLabelSettings(
                            isVisible:
                                true, // Tampilkan label angka di tiap titik
                          ),
                          enableTooltip:
                              true, // Tampilkan tooltip saat disentuh
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              // Jika data ksng akn menampilkan
              const Expanded(
                child: Center(child: Text('Tidak ada data untuk ditampilkan')),
              ),
          ],
        ),
      ),
    );
  }
}

// Kelas untuk memetakan data yang ditampilkan di chart
class GrafikData {
  final String name;
  final int quantity;

  GrafikData(this.name, this.quantity);
}
