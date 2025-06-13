import 'package:flutter/material.dart';
import 'package:shopping_list/database/db_helper.dart';
import 'package:shopping_list/screens/add_item_screen.dart';
import 'package:shopping_list/screens/edit_item_screen.dart';
import 'package:shopping_list/screens/profile_screen.dart';
import 'package:shopping_list/screens/statistik_screen.dart';

class ShoppingListScreen extends StatefulWidget {
  final int userId;
  const ShoppingListScreen({super.key, required this.userId});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  List<Map<String, dynamic>> items = [];
  List<Map<String, dynamic>> filteredItems = [];
  String searchQuery = '';
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    muatItems();
  }

  Future<void> muatItems() async {
    final data = await DBHELPER13.getItemsByUser(widget.userId);
    setState(() {
      items = data;
      filteredItems = applySearch(data, searchQuery);
    });
  }

  List<Map<String, dynamic>> applySearch(
    List<Map<String, dynamic>> data,
    String query,
  ) {
    if (query.isEmpty) return data;

    return data
        .where(
          (item) => item['name'].toString().toLowerCase().contains(
            query.toLowerCase(),
          ),
        )
        .toList();
  }

  Future<void> deleteItem(int id) async {
    await DBHELPER13.deleteItem(id);
    await muatItems();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Item dihapus')));
  }

  Widget buildShoppingListView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Total catatan: ${filteredItems.length}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Cari item...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                  filteredItems = applySearch(items, searchQuery);
                });
              },
            ),
          ),
          const SizedBox(height: 10),

          if (filteredItems.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Center(
                child: Text(
                  'Tidak ada Data',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ),
            )
          else
            for (var item in filteredItems)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        item['isDone'] == 1 ? Colors.grey[300] : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
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
                    children: [
                      Checkbox(
                        value: item['isDone'] == 1,
                        onChanged: (value) async {
                          await DBHELPER13.updateItem(
                            item['id'],
                            item['name'],
                            item['deskripsi'],
                            item['Toko'],
                            item['quantity'],
                            (value ?? false) ? 1 : 0,
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
                              'Deskripsi: ${item['deskripsi']}',
                              style: const TextStyle(color: Colors.grey),
                            ),
                            Text(
                              'Toko: ${item['Toko']}',
                              style: const TextStyle(color: Colors.grey),
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
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  title: const Text('Konfirmasi'),
                                  content: const Text(
                                    'Apakah kamu yakin ingin menghapus item ini?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () =>
                                              Navigator.of(context).pop(false),
                                      child: const Text('Tidak'),
                                    ),
                                    TextButton(
                                      onPressed:
                                          () => Navigator.of(context).pop(true),
                                      child: const Text(
                                        'Ya',
                                        style: TextStyle(
                                          color: Color(0xffDC2525),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                          );

                          if (confirm == true) {
                            await deleteItem(item['id']);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F9FF),
      body: IndexedStack(
        index: selectedIndex,
        children: [
          buildShoppingListView(),
          StatistikScreen(userId: widget.userId),
          ProfileScreen(userId: widget.userId),
        ],
      ),
      floatingActionButton:
          selectedIndex == 0
              ? FloatingActionButton.extended(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddItemScreen(userId: widget.userId),
                    ),
                  );
                  await muatItems();
                },
                backgroundColor: const Color(0xffC5BAFF),
                icon: const Icon(Icons.add),
                label: const Text('Tambah Item'),
              )
              : null,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xffC4D9FF),
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        selectedItemColor: const Color.fromARGB(255, 73, 63, 88),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.note_alt_outlined, color: Color(0xffC599B6)),
            label: 'produk',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.stacked_bar_chart, color: Color(0xffC599B6)),
            label: 'Statistik',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Color(0xffC599B6)),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
