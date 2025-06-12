import 'package:flutter/material.dart';
import 'package:shopping_list/database/db_helper.dart';

class EditItemScreen extends StatefulWidget {
  final Map<String, dynamic> item;

  const EditItemScreen({super.key, required this.item});

  @override
  State<EditItemScreen> createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController deskripsiController;
  late TextEditingController tokoController;
  late TextEditingController quantityController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with the current item's data
    nameController = TextEditingController(text: widget.item['name']);
    deskripsiController = TextEditingController(text: widget.item['deskripsi']);
    tokoController = TextEditingController(text: widget.item['Toko']);
    quantityController = TextEditingController(
      text: widget.item['quantity'].toString(),
    );
  }

  // Function to update the item in the database
  Future<void> updateItem() async {
    if (_formKey.currentState!.validate()) {
      int id = widget.item['id']; // Get the item's ID
      String name = nameController.text;
      String deskripsi = deskripsiController.text;
      String toko = tokoController.text;
      int quantity = int.parse(quantityController.text);
      int isDone = widget.item['isDone'] ?? 0; // Preserve the isDone status

      await DBHELPER13.updateItem(id, name, deskripsi, toko, quantity, isDone);

      Navigator.pop(
        context,
      ); // Go back to the previous screen (ShoppingListScreen)
    }
  }

  // Helper widget to build text form fields
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Item')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
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
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: updateItem,
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
