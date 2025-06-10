// edit_item_screen.dart
import 'package:flutter/material.dart';
import 'package:shopping_list/database/db_helper.dart';

class EditItemScreen extends StatefulWidget {
  final Map<String, dynamic> item;
  const EditItemScreen({super.key, required this.item});

  @override
  State<EditItemScreen> createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  late TextEditingController nameController;
  late TextEditingController quantityController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    nameController = TextEditingController(text: widget.item['name']);
    quantityController = TextEditingController(
      text: widget.item['quantity'].toString(),
    );
    super.initState();
  }

  Future<void> updateItem() async {
    if (_formKey.currentState!.validate()) {
      int id = widget.item['id'];
      String name = nameController.text;
      int quantity = int.parse(quantityController.text);
      bool isDone = widget.item['isDone'] == 1;

      await DBHELPER13.updateItem(id, name, quantity, isDone);

      Navigator.pop(context);
    }
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
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nama Item'),
                validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: quantityController,
                decoration: const InputDecoration(labelText: 'Jumlah'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: updateItem,
                child: const Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
