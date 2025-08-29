import 'package:flutter/material.dart';
import 'package:project_artee/services/confirm_payment_api.dart';

class ConfirmPaymentPage extends StatefulWidget {
  const ConfirmPaymentPage({super.key});

  @override
  State<ConfirmPaymentPage> createState() => _ConfirmPaymentPageState();
}

class _ConfirmPaymentPageState extends State<ConfirmPaymentPage> {
  List<Map<String, dynamic>> payments = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadPayments();
  }

  Future<void> loadPayments() async {
    try {
      final data = await PaymentService.fetchPayments();
      setState(() {
        payments = data.where((p) => p['status'] == "PENDING").toList();
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("โหลดข้อมูลล้มเหลว: $e")));
    }
  }

  Future<void> confirmPayment(int id) async {
    try {
      await PaymentService.updateStatus(id, "CONFIRMED");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("ยืนยันการชำระเงินสำเร็จ")));
      loadPayments();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("ไม่สามารถยืนยันได้: $e")));
    }
  }

  Future<void> cancelPayment(int id) async {
    try {
      await PaymentService.updateStatus(id, "CANCELLED");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("ยกเลิกการชำระเงินเรียบร้อย")),
      );
      loadPayments();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("ไม่สามารถยกเลิกได้: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("ยืนยันการชำระเงิน")),
      body:
          payments.isEmpty
              ? const Center(child: Text("ไม่มีการชำระเงินรอการยืนยัน"))
              : ListView.builder(
                itemCount: payments.length,
                itemBuilder: (context, index) {
                  final p = payments[index];
                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      title: Text("OrderNo: ${p['orderNo']}"),
                      subtitle: Text("จำนวนเงิน: ${p['totalCost']} บาท"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.check, color: Colors.green),
                            onPressed: () => confirmPayment(p['paymentNo']),
                          ),
                          IconButton(
                            icon: const Icon(Icons.cancel, color: Colors.red),
                            onPressed: () => cancelPayment(p['paymentNo']),
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
