import 'package:flutter/material.dart';
import 'package:shopping_list/database/db_helper.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StatistikScreen extends StatefulWidget {
  const StatistikScreen({super.key});
  static const String id = '/statistik';

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
    final data = await DBHELPER13.getAllItems();
    setState(() {
      items = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Buat list data untuk chart
    final chartData =
        items
            .map(
              (item) =>
                  _ChartData(item['name'] as String, item['quantity'] as int),
            )
            .toList();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // untuk buang panah secara paksa!!!!
        title: const Text('Statistik Belanja'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadItems, // Tombol refresh
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
            if (chartData.isNotEmpty)
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: items.length * 100.0, // Ukuran horizontal dinamis
                    child: SfCartesianChart(
                      primaryXAxis: CategoryAxis(),
                      primaryYAxis: NumericAxis(
                        title: AxisTitle(text: 'Quantity'),
                        interval: 10,
                        minimum: 0,
                      ),
                      tooltipBehavior: TooltipBehavior(enable: true),
                      series: <LineSeries<_ChartData, String>>[
                        LineSeries<_ChartData, String>(
                          dataSource: chartData,
                          xValueMapper: (_ChartData data, _) => data.name,
                          yValueMapper: (_ChartData data, _) => data.quantity,
                          dataLabelSettings: const DataLabelSettings(
                            isVisible: true,
                          ),
                          enableTooltip: true,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              const Expanded(
                child: Center(child: Text('Tidak ada data untuk ditampilkan')),
              ),
          ],
        ),
      ),
    );
  }
}

class _ChartData {
  final String name;
  final int quantity;

  _ChartData(this.name, this.quantity);
}
