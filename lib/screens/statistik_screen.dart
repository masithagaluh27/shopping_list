import 'package:flutter/material.dart';
import 'package:shopping_list/database/db_helper.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StatistikScreen extends StatefulWidget {
  final int userId;
  const StatistikScreen({super.key, required this.userId});

  @override
  State<StatistikScreen> createState() => _StatistikScreenState();
}

class _StatistikScreenState extends State<StatistikScreen> {
  List<Map<String, dynamic>> items = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final data = await DBHELPER13.getItemsByUser(widget.userId);
    setState(() {
      items = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    // untuk mengkonversi list items menjadi list chartData
    final chartData =
        items
            .map(
              (item) =>
                  GrafikData(item['name'] as String, item['quantity'] as int),
            )
            .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffC4D9FF),

        // u/ menghapus panah kiri dg paksa!!!
        automaticallyImplyLeading: false,
        title: const Text('Statistik Belanja'),

        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadItems, //u/ memuat data
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

            // Jika data ada u/ ditampilkan
            if (chartData.isNotEmpty)
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    // u/ Ukuran lebar agar jumlah item tidak sempit (horizontal)
                    width: items.length * 100.0,
                    child: SfCartesianChart(
                      // pakai itu karena kompatibel dg sumbu x dan y

                      //primary = sumbu utama (bisa diubah)
                      primaryXAxis: CategoryAxis(),
                      primaryYAxis: NumericAxis(
                        title: AxisTitle(text: 'Quantity'),
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
                            isVisible: true, // angka di titik
                          ),
                          enableTooltip: true, // label data
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
