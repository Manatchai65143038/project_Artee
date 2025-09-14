import 'package:flutter/material.dart';
import '../services/detail_order_api.dart';

class CancelOrderPage extends StatefulWidget {
  const CancelOrderPage({super.key});

  @override
  State<CancelOrderPage> createState() => _CancelOrderPageState();
}

class _CancelOrderPageState extends State<CancelOrderPage> {
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

  Future<void> _cancelOrder(DetailOrder order) async {
    TextEditingController descriptionController = TextEditingController();
    List<String> cancelReasons = [
      "ทำผิดเมนู",
      "ลูกค้ายกเลิก",
      "วัตถุดิบหมด",
      "เหตุผลอื่น ๆ",
    ];
    List<String> selectedReasons = [];

    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text("ยกเลิกออเดอร์"),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("เลือกเหตุผลการยกเลิก:"),
                      const SizedBox(height: 8),
                      ...cancelReasons.map((reason) {
                        return CheckboxListTile(
                          value: selectedReasons.contains(reason),
                          title: Text(reason),
                          controlAffinity: ListTileControlAffinity.leading,
                          onChanged: (checked) {
                            setState(() {
                              if (checked == true) {
                                selectedReasons.add(reason);
                              } else {
                                selectedReasons.remove(reason);
                              }
                            });
                          },
                        );
                      }).toList(),
                      const Divider(),
                      const Text("เหตุผลเพิ่มเติม:"),
                      const SizedBox(height: 8),
                      TextField(
                        controller: descriptionController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "ระบุเหตุผลเพิ่มเติม...",
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text("ยกเลิก"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text("ตกลง"),
                  ),
                ],
              );
            },
          ),
    );

    if (confirm != true) return;

    final description = [
      ...selectedReasons,
      descriptionController.text.trim(),
    ].where((e) => e.isNotEmpty).join(" | ");

    if (description.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("กรุณากรอกเหตุผลการยกเลิก")));
      return;
    }

    bool success = await DetailOrderService.cancelOrder(
      detailNo: order.detailNo,
      orderNo: order.orderNo,
      description: description,
      cancelBy: "พนักงาน",
    );

    if (!mounted) return;

    if (success) {
      setState(() {
        currentOrders.removeWhere((o) => o.detailNo == order.detailNo);
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("ยกเลิกออเดอร์สำเร็จ")));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("ยกเลิกออเดอร์ไม่สำเร็จ")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final menuTypes = currentOrders.map((o) => o.menuType).toSet().toList();

    // กรองออร์เดอร์ตามประเภทที่เลือก
    final filteredOrders =
        selectedType == null
            ? currentOrders
            : currentOrders.where((o) => o.menuType == selectedType).toList();

    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        backgroundColor: Colors.deepOrange.shade700,
        title: const Text(
          "จัดการออเดอร์",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 6,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: Column(
        children: [
          if (menuTypes.isNotEmpty)
            // Dropdown ฟิลเตอร์แบบ Card สีเขียว
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: Colors.green[50],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String?>(
                      isExpanded: true,
                      hint: const Text(
                        "เลือกประเภทอาหาร",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      value: selectedType,
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.green,
                      ),
                      dropdownColor: Colors.green[50],
                      items: [
                        const DropdownMenuItem<String?>(
                          value: null,
                          child: Text("ทั้งหมด"),
                        ),
                        ...menuTypes.map(
                          (type) => DropdownMenuItem<String?>(
                            value: type,
                            child: Text(
                              type ?? "-",
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedType = value;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),

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
                                                        (_, __, ___) =>
                                                            const Icon(
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
                                                Icons.cancel,
                                                size: 18,
                                              ),
                                              label: const Text(
                                                "ยกเลิก",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 8,
                                                    ),
                                              ),
                                              onPressed:
                                                  () => _cancelOrder(order),
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
