import 'package:flutter/material.dart';

class CancelOrderPage extends StatefulWidget {
  const CancelOrderPage({super.key});

  @override
  State<CancelOrderPage> createState() => _CancelOrderPageState();
}

class _CancelOrderPageState extends State<CancelOrderPage> {
  List<Map<String, dynamic>> orders = [
    {
      'id': 'ORD001',
      'table': 'โต๊ะ 1',
      'items': ['โจ๊ก', 'น้ำส้ม'],
      'status': 'กำลังเตรียมอาหาร',
    },
    {
      'id': 'ORD002',
      'table': 'โต๊ะ 3',
      'items': ['ข้าวผัด', 'โค้ก'],
      'status': 'รอเสิร์ฟ',
    },
    {
      'id': 'ORD003',
      'table': 'โต๊ะ 5',
      'items': ['ข้าวมันไก่'],
      'status': 'ยังไม่เริ่ม',
    },
  ];

  void cancelOrder(int index) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('ยืนยันการยกเลิก'),
            content: Text(
              'คุณต้องการยกเลิกออเดอร์ ${orders[index]['id']} หรือไม่?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('ไม่'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    orders.removeAt(index);
                  });
                  Navigator.pop(context);
                },
                child: const Text(
                  'ยกเลิกออเดอร์',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cancel Order'),
        backgroundColor: Colors.redAccent,
      ),
      body:
          orders.isEmpty
              ? const Center(child: Text('ไม่มีออเดอร์ที่สามารถยกเลิกได้'))
              : ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListTile(
                      title: Text('รหัสออเดอร์: ${order['id']}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('โต๊ะ: ${order['table']}'),
                          Text('เมนู: ${order['items'].join(', ')}'),
                          Text('สถานะ: ${order['status']}'),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.cancel, color: Colors.red),
                        onPressed: () => cancelOrder(index),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
