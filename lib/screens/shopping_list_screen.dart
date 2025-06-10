import 'package:flutter/material.dart';
import 'package:shopping_list/database/db_helper.dart';
import 'package:shopping_list/screens/edit_item_screen.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});
  static const String id = '/shopping_list';

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  List<Map<String, dynamic>> items = [];
  TextEditingController searchController = TextEditingController();
  String query = '';

  @override
  void initState() {
    super.initState();
    muatItems();
  }

  Future<void> muatItems() async {
    final data = await DBHELPER13.getAllItems();
    setState(() {
      items =
          data
              .where(
                (item) => item['name'].toString().toLowerCase().contains(
                  query.toLowerCase(),
                ),
              )
              .toList();
    });
  }

  Future<void> deleteItem(int id) async {
    await DBHELPER13.deleteItem(id);
    muatItems();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Item dihapus')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F9FF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header / AppBar
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    color: Color(0xffC4D9FF),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(32),
                      bottomRight: Radius.circular(32),
                    ),
                  ),
                  child: const Text(
                    'Shopping\nlist.',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Total Notes
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Total catatan: ${items.length}',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),

                const SizedBox(height: 8),

                // Search Box
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.search),
                        hintText: 'Cari item...',
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        setState(() {
                          query = value;
                        });
                        muatItems();
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // List of Items (as Container, no Card)
                ...items.map((item) {
                  bool isDone = item['isDone'] == 1;

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDone ? Colors.grey[300] : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: isDone,
                            onChanged: (value) async {
                              await DBHELPER13.updateItem(
                                item['id'],
                                item['name'],
                                item['quantity'],
                                value ?? false,
                              );
                              await muatItems();
                            },
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['name'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  'Quantity: ${item['quantity']}',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EditItemScreen(item: item),
                                ),
                              );
                              await muatItems();
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => deleteItem(item['id']),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),

      // Floating Button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.pushNamed(context, '/add_item');
          await muatItems();
        },
        backgroundColor: const Color(0xff8F87F1),
        icon: const Icon(Icons.add),
        label: const Text('Tambah Item'),
      ),
    );
  }
}
