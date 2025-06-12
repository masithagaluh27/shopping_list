import 'package:flutter/material.dart';
import 'package:shopping_list/database/db_helper.dart';

class AddItemScreen extends StatefulWidget {
  final int userId;

  const AddItemScreen({super.key, required this.userId});
  // static const String id = '/add_item';

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>(); //u/ validasi

  final nameController = TextEditingController();
  final deskripsiController = TextEditingController();
  final tokoController = TextEditingController();
  final quantityController = TextEditingController();

  Future<void> saveItem() async {
    if (_formKey.currentState!.validate()) {
      final name = nameController.text;
      final deskripsi = deskripsiController.text;
      final toko = tokoController.text;
      final quantity = int.parse(quantityController.text);

      await DBHELPER13.insertItem(
        widget.userId, // pakai wiget u/ mengambil ID dr halaman sblmny
        name,
        deskripsi,
        toko,
        quantity,
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Item')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey, //u/ validasi
          child: Column(
            children: [
              buildTextField(nameController, 'Nama Item'),
              const SizedBox(height: 16),

              buildTextField(deskripsiController, 'Deskripsi'),
              const SizedBox(height: 16),

              buildTextField(tokoController, 'Nama Toko'),
              const SizedBox(height: 16),

              buildTextField(
                quantityController,
                'Jumlah',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24),

              // Tombol Simpan
              SizedBox(
                width: double.infinity, // tmbl yg luwes
                child: ElevatedButton(
                  onPressed: saveItem,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: const StadiumBorder(),
                    backgroundColor: Colors.blue.shade900,
                  ),
                  child: const Text(
                    'Simpan',
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

  Widget buildTextField(
    TextEditingController controller,
    String label, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: 'Masukkan $label',
        hintStyle: const TextStyle(fontSize: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
      ),

      validator:
          (value) => value == null || value.isEmpty ? 'Wajib diisi' : null,
    );
  }
}
