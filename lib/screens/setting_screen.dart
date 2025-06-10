import 'package:flutter/material.dart';
import 'package:shopping_list/database/db_helper.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});
  static const String id = '/settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Statistik & Info')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DBHELPER13.getAllItems(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final items = snapshot.data!;
          final done = items.where((i) => i['isDone'] == 1).length;
          final total = items.length;

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Total item: $total'),
                Text('Item selesai: $done'),
                Text('Belum selesai: ${total - done}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
