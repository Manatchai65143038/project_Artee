import 'package:flutter/material.dart';

class FoodStatusPage extends StatefulWidget {
  const FoodStatusPage({super.key});

  @override
  State<FoodStatusPage> createState() => _FoodStatusPageState();
}

class _FoodStatusPageState extends State<FoodStatusPage> {
  List<Map<String, dynamic>> foodList = [
    {'name': 'เมนู A', 'available': true},
  ];

  final TextEditingController _nameController = TextEditingController();

  void _addFood() {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("เพิ่มเมนูอาหาร"),
            content: TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "ชื่อเมนู"),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _nameController.clear();
                },
                child: const Text("ยกเลิก"),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    foodList.add({
                      'name': _nameController.text,
                      'available': true,
                    });
                  });
                  Navigator.pop(context);
                  _nameController.clear();
                },
                child: const Text("เพิ่ม"),
              ),
            ],
          ),
    );
  }

  void _editFood(int index) {
    _nameController.text = foodList[index]['name'];
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("แก้ไขชื่อเมนู"),
            content: TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "ชื่อเมนู"),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _nameController.clear();
                },
                child: const Text("ยกเลิก"),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    foodList[index]['name'] = _nameController.text;
                  });
                  Navigator.pop(context);
                  _nameController.clear();
                },
                child: const Text("บันทึก"),
              ),
            ],
          ),
    );
  }

  void _deleteFood(int index) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("ยืนยันการลบ"),
            content: Text(
              "ต้องการลบเมนู '${foodList[index]['name']}' หรือไม่?",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("ยกเลิก"),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    foodList.removeAt(index);
                  });
                  Navigator.pop(context);
                },
                child: const Text("ลบ"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('จัดการเมนูอาหาร'),
        actions: [IconButton(icon: const Icon(Icons.add), onPressed: _addFood)],
      ),
      body: ListView.builder(
        itemCount: foodList.length,
        itemBuilder: (context, index) {
          final food = foodList[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(food['name']),
              subtitle: Text(
                food['available'] ? 'สามารถสั่งได้' : 'สินค้านี้หมด',
                style: TextStyle(
                  color: food['available'] ? Colors.green : Colors.red,
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _editFood(index),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Switch(
                    value: food['available'],
                    onChanged: (value) {
                      setState(() {
                        foodList[index]['available'] = value;
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteFood(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
