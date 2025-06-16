import 'package:flutter/material.dart';
import 'package:shopping_list/database/db_helper.dart';

class EditItemScreen extends StatefulWidget {
  final Map<String, dynamic> item;

  const EditItemScreen({super.key, required this.item});

  @override
  State<EditItemScreen> createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  final _formKey = GlobalKey<FormState>(); // Buat validasi form

  late TextEditingController nameController;
  late TextEditingController deskripsiController;
  late TextEditingController tokoController;
  late TextEditingController quantityController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(
      text: widget.item['name'],
    ); //pakai widget bcs mengambil data dr luar
    deskripsiController = TextEditingController(text: widget.item['deskripsi']);
    tokoController = TextEditingController(text: widget.item['Toko']);
    quantityController = TextEditingController(
      text: widget.item['quantity'].toString(),
    );
  }

  Future<void> updateItem() async {
    if (_formKey.currentState!.validate()) {
      int id = widget.item['id'];
      String name = nameController.text;
      String deskripsi = deskripsiController.text;
      String toko = tokoController.text;
      int quantity = int.parse(quantityController.text);
      int isDone = widget.item['isDone'] ?? 0;

      //edit item
      //u/ update ke database
      await DBHELPER13.updateItem(id, name, deskripsi, toko, quantity, isDone);

      // Menampilkan snackbar setelah berhasil update
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Item berhasil diupdate!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );

      // Tunggu sebentar supaya snackbar sempat tampil
      await Future.delayed(const Duration(milliseconds: 500));

      // Kembali ke halaman sebelumnya
      Navigator.pop(context);
    }
  }

  Widget buildTextField(
    TextEditingController controller,
    String label, {
    TextInputType keyboardType = TextInputType.text,
    IconData? icon,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintStyle: const TextStyle(fontSize: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        prefixIcon: icon != null ? Icon(icon) : null,
      ),

      validator:
          (value) => value == null || value.isEmpty ? 'Wajib diisi' : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Item')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey, // u/ validasi
          child: Column(
            children: [
              buildTextField(nameController, 'Nama Item'),
              const SizedBox(height: 16),
              buildTextField(
                deskripsiController,
                'Deskripsi',
                icon: Icons.description,
              ),
              const SizedBox(height: 16),
              buildTextField(tokoController, 'Nama Toko', icon: Icons.store),
              const SizedBox(height: 16),
              buildTextField(
                quantityController,
                'Jumlah',
                keyboardType: TextInputType.number,
                icon: Icons.format_list_numbered,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: updateItem, // u/ menyimpan perubahan
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: const StadiumBorder(),
                    backgroundColor: Colors.blue.shade900,
                  ),
                  child: const Text(
                    'Update',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
