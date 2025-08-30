import 'package:flutter/material.dart';
import 'package:project_artee/services/cancel_order_api.dart';

// ยังไม่สมบูรณ์

class CancelOrderPage extends StatefulWidget {
  const CancelOrderPage({super.key});

  @override
  State<CancelOrderPage> createState() => _CancelOrderPageState();
}

class _CancelOrderPageState extends State<CancelOrderPage> {
  List<Map<String, dynamic>> cancelLogs = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadCancelLogs();
  }

  Future<void> loadCancelLogs() async {
    try {
      final data = await CancelOrderService.fetchCancelLogs();
      if (!mounted) return;
      setState(() {
        cancelLogs = List<Map<String, dynamic>>.from(data);
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => loading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("โหลดข้อมูลล้มเหลว: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: const Text("บันทึกการยกเลิกออเดอร์")),
      body:
          cancelLogs.isEmpty
              ? const Center(child: Text("ไม่มีข้อมูลการยกเลิก"))
              : ListView.builder(
                itemCount: cancelLogs.length,
                itemBuilder: (context, index) {
                  final log = cancelLogs[index];
                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      title: Text(
                        "OrderNo: ${log['orderNo']} | DetailNo: ${log['detailNo']}",
                      ),
                      subtitle: Text(
                        "เหตุผล: ${log['description']}\nผู้ยกเลิก: ${log['cancelBy']}",
                      ),
                      trailing: Text(
                        log['createAt'] ?? "",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
