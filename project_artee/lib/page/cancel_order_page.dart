import 'package:flutter/material.dart';
import 'package:project_artee/services/cancel_order_api.dart';

class CancelOrderPage extends StatefulWidget {
  const CancelOrderPage({super.key});

  @override
  State<CancelOrderPage> createState() => _CancelOrderPageState();
}

class _CancelOrderPageState extends State<CancelOrderPage> {
  List<Map<String, dynamic>> cancelLogs = [];
  bool loading = true;

  final TextEditingController detailNoController = TextEditingController();
  final TextEditingController orderNoController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController cancelByController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadCancelLogs();
  }

  Future<void> loadCancelLogs() async {
    try {
      final data = await CancelOrderService.fetchCancelLogs();
      setState(() {
        cancelLogs = List<Map<String, dynamic>>.from(data);
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("โหลดข้อมูลล้มเหลว: $e")));
    }
  }

  Future<void> addCancelLog() async {
    try {
      await CancelOrderService.addCancelLog(
        detailNo: int.parse(detailNoController.text),
        orderNo: int.parse(orderNoController.text),
        description: descriptionController.text,
        cancelBy: cancelByController.text,
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("เพิ่มการยกเลิกสำเร็จ")));
      loadCancelLogs(); // refresh
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("เพิ่มการยกเลิกไม่สำเร็จ: $e")));
    }
  }

  void openAddDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("ยกเลิกออเดอร์"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: detailNoController,
                    decoration: const InputDecoration(labelText: "Detail No"),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: orderNoController,
                    decoration: const InputDecoration(labelText: "Order No"),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(labelText: "รายละเอียด"),
                  ),
                  TextField(
                    controller: cancelByController,
                    decoration: const InputDecoration(labelText: "ผู้ยกเลิก"),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("ยกเลิก"),
              ),
              ElevatedButton(
                onPressed: () {
                  addCancelLog();
                  Navigator.pop(context);
                },
                child: const Text("บันทึก"),
              ),
            ],
          ),
    );
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
      floatingActionButton: FloatingActionButton(
        onPressed: openAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
