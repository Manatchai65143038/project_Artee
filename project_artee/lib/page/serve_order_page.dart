import 'package:flutter/material.dart';
import '../services/detail_order_api.dart';

class ServeOrderPage extends StatefulWidget {
  const ServeOrderPage({super.key});

  @override
  State<ServeOrderPage> createState() => _ServeOrderPageState();
}

class _ServeOrderPageState extends State<ServeOrderPage> {
  late Future<List<DetailOrder>> futureOrders;
  List<DetailOrder> currentOrders = [];
  String? selectedType; // ฟิลเตอร์ประเภทอาหาร

  @override
  void initState() {
    super.initState();
    futureOrders = DetailOrderService.fetchDetailOrders();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    try {
      final orders = await futureOrders;
      if (!mounted) return;
      setState(() {
        // Filter เฉพาะ trackOrderID = 2 (ready to serve)
        currentOrders = orders.where((o) => o.trackOrderID == 2).toList();
      });
    } catch (_) {
      // ไม่แสดง SnackBar
    }
  }

  Future<void> _serveOrder(DetailOrder order) async {
    bool success = await DetailOrderService.updateTrack(order.detailNo, 3);
    if (!mounted) return;

    if (success) {
      setState(() {
        currentOrders.removeWhere((o) => o.detailNo == order.detailNo);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // ดึงประเภทเมนูทั้งหมดจาก currentOrders
    final types = currentOrders.map((o) => o.menuType).toSet().toList();

    // กรองออร์เดอร์ตามประเภทที่เลือก
    final filteredOrders =
        selectedType == null
            ? currentOrders
            : currentOrders.where((o) => o.menuType == selectedType).toList();

    return Scaffold(
      backgroundColor: Colors.orange[50], // พื้นหลังอ่อน
      appBar: AppBar(
        backgroundColor: Colors.deepOrange.shade700,
        title: const Text(
          "เสิร์ฟอาหาร",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 6,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20), // โค้งด้านล่าง
          ),
        ),
      ),
      body: Column(
        children: [
          // Dropdown ฟิลเตอร์ประเภทอาหาร
          if (types.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton<String>(
                isExpanded: true,
                hint: const Text("เลือกประเภทอาหาร"),
                value: selectedType,
                items: [
                  const DropdownMenuItem(value: null, child: Text("ทั้งหมด")),
                  ...types.map(
                    (type) =>
                        DropdownMenuItem(value: type, child: Text(type ?? "-")),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedType = value;
                  });
                },
              ),
            ),

          // ตารางออร์เดอร์
          Expanded(
            child:
                filteredOrders.isEmpty
                    ? const Center(child: Text("ไม่มีออเดอร์"))
                    : LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: constraints.maxWidth,
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: DataTable(
                                headingRowColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.green[200]!,
                                ),
                                columnSpacing: 12,
                                dataRowHeight: 70,
                                columns: const [
                                  DataColumn(label: Text("ลำดับ")),
                                  DataColumn(label: Text("เมนู")),
                                  DataColumn(label: Text("ประเภท")),
                                  DataColumn(label: Text("จำนวน")),
                                  DataColumn(label: Text("โต๊ะ")),
                                  DataColumn(label: Text("คำขอเพิ่มเติม")),
                                  DataColumn(label: Text("สถานที่")),
                                  DataColumn(label: Text("จัดการ")),
                                ],
                                rows:
                                    filteredOrders.map((order) {
                                      return DataRow(
                                        cells: [
                                          DataCell(
                                            Text(order.detailNo.toString()),
                                          ),
                                          DataCell(
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  child: Image.network(
                                                    order.menuImage ?? "",
                                                    width: 50,
                                                    height: 50,
                                                    fit: BoxFit.cover,
                                                    errorBuilder:
                                                        (
                                                          context,
                                                          error,
                                                          stack,
                                                        ) => const Icon(
                                                          Icons.fastfood,
                                                        ),
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Flexible(
                                                  child: Text(
                                                    order.menuName ?? "",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.deepOrange,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          DataCell(Text(order.menuType ?? "")),
                                          DataCell(
                                            Text(order.amount.toString()),
                                          ),
                                          DataCell(
                                            Text(order.tableNo.toString()),
                                          ),
                                          DataCell(
                                            Text(order.description ?? ""),
                                          ),
                                          DataCell(Text(order.place ?? "")),
                                          DataCell(
                                            ElevatedButton.icon(
                                              icon: const Icon(
                                                Icons.restaurant,
                                                size: 18,
                                              ),
                                              label: const Text(
                                                "เสิร์ฟ",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.orange,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 8,
                                                    ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                              ),
                                              onPressed:
                                                  () => _serveOrder(order),
                                            ),
                                          ),
                                        ],
                                      );
                                    }).toList(),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
