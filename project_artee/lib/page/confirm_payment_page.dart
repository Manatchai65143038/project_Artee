import 'package:flutter/material.dart';

class ConfirmPaymentPage extends StatefulWidget {
  const ConfirmPaymentPage({super.key});

  @override
  State<ConfirmPaymentPage> createState() => _ConfirmPaymentPageState();
}

class _ConfirmPaymentPageState extends State<ConfirmPaymentPage> {
  List<Map<String, dynamic>> payments = [
    {
      'orderId': 'ORD001',
      'table': 'โต๊ะ 1',
      'total': 250,
      'status': 'รอชำระเงิน',
    },
    {
      'orderId': 'ORD002',
      'table': 'โต๊ะ 2',
      'total': 120,
      'status': 'รอชำระเงิน',
    },
    {
      'orderId': 'ORD003',
      'table': 'โต๊ะ 3',
      'total': 80,
      'status': 'รอชำระเงิน',
    },
  ];

  void confirmPayment(int index) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('ยืนยันการชำระเงิน'),
            content: Text(
              'คุณต้องการยืนยันว่ารับเงินสำหรับออเดอร์ ${payments[index]['orderId']} แล้วหรือไม่?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('ยกเลิก'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    payments[index]['status'] = 'ชำระเงินแล้ว';
                  });
                  Navigator.pop(context);
                },
                child: const Text(
                  'ยืนยัน',
                  style: TextStyle(color: Colors.green),
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
        title: const Text('Confirm Payment'),
        backgroundColor: Colors.green,
      ),
      body:
          payments.isEmpty
              ? const Center(child: Text('ไม่มีออเดอร์ที่รอการชำระเงิน'))
              : ListView.builder(
                itemCount: payments.length,
                itemBuilder: (context, index) {
                  final payment = payments[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListTile(
                      title: Text('ออเดอร์: ${payment['orderId']}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('โต๊ะ: ${payment['table']}'),
                          Text('ยอดรวม: ${payment['total']} บาท'),
                          Text('สถานะ: ${payment['status']}'),
                        ],
                      ),
                      trailing:
                          payment['status'] == 'รอชำระเงิน'
                              ? IconButton(
                                icon: const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                ),
                                onPressed: () => confirmPayment(index),
                              )
                              : const Icon(Icons.verified, color: Colors.grey),
                    ),
                  );
                },
              ),
    );
  }
}
