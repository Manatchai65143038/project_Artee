import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:project_artee/services/detail_order_api.dart';

class DetailOrderPage extends StatefulWidget {
  const DetailOrderPage({super.key});

  @override
  State<DetailOrderPage> createState() => _DetailOrderPageState();
}

class _DetailOrderPageState extends State<DetailOrderPage> {
  late Future<List<DetailOrder>> futureOrders;
  List<DetailOrder> currentOrders = [];
  String? selectedMenuType;

  @override
  void initState() {
    super.initState();
    futureOrders = DetailOrderService.fetchDetailOrders();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    try {
      final orders = await futureOrders;
      setState(() {
        // ✅ Filter เฉพาะ trackOrderID = 1
        currentOrders = orders.where((o) => o.trackOrderID == 1).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("เกิดข้อผิดพลาดโหลดออเดอร์: $e")));
    }
  }

  Future<void> _acceptOrder(DetailOrder order) async {
    // trackId = 2 สำหรับ "รับออเดอร์"
    bool success = await DetailOrderService.updateTrack(order.detailNo, 2);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green[600],
          content: Text("✅ รับออเดอร์ ${order.detailNo} สำเร็จ"),
        ),
      );
      setState(() {
        // ✅ ลบออกจาก currentOrders
        currentOrders.removeWhere((o) => o.detailNo == order.detailNo);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red[400],
          content: const Text("❌ รับออเดอร์ไม่สำเร็จ"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // ดึงประเภทเมนูไม่ซ้ำ สำหรับฟิลเตอร์
    final menuTypes = currentOrders.map((o) => o.menuType).toSet().toList();
    final filteredOrders =
        selectedMenuType == null
            ? currentOrders
            : currentOrders
                .where((o) => o.menuType == selectedMenuType)
                .toList();

    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: const Text(
          "📋 ออเดอร์ของลูกค้า",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Dropdown filter
          if (menuTypes.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton<String>(
                isExpanded: true,
                hint: const Text("เลือกประเภทเมนู"),
                value: selectedMenuType,
                items: [
                  const DropdownMenuItem(value: null, child: Text("ทั้งหมด")),
                  ...menuTypes.map(
                    (type) => DropdownMenuItem(value: type, child: Text(type)),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedMenuType = value;
                  });
                },
              ),
            ),

          // ตารางออเดอร์
          Expanded(
            child:
                filteredOrders.isEmpty
                    ? const Center(child: Text("ไม่มีออเดอร์"))
                    : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: MediaQuery.of(context).size.width,
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: DataTable(
                            headingRowColor: MaterialStateColor.resolveWith(
                              (states) => Colors.green[200]!,
                            ),
                            columnSpacing: 12,
                            columns: const [
                              DataColumn(label: Text("ลำดับ")),
                              DataColumn(label: Text("เมนู")),
                              DataColumn(label: Text("ประเภท")),
                              DataColumn(label: Text("จำนวน")),
                              DataColumn(label: Text("โต๊ะ")),
                              DataColumn(label: Text("จัดการ")),
                            ],
                            rows:
                                filteredOrders.map((order) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(order.detailNo.toString())),
                                      DataCell(
                                        Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image.network(
                                                order.menuImage,
                                                width: 40,
                                                height: 40,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            SizedBox(
                                              width: 100,
                                              child: Text(
                                                order.menuName,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.deepOrange,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      DataCell(Text(order.menuType)),
                                      DataCell(Text(order.amount.toString())),
                                      DataCell(Text(order.tableNo.toString())),
                                      DataCell(
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                          ),
                                          child: const Text("รับออเดอร์"),
                                          onPressed: () => _acceptOrder(order),
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                          ),
                        ),
                      ),
                    ),
          ),
        ],
      ),
    );
  }
}
