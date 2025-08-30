import 'package:flutter/material.dart';
import 'package:project_artee/services/menu_api.dart';

// 📋 แสดงตารางเมนู (โทนเขียว+ส้ม)
class MenuTablePage extends StatefulWidget {
  const MenuTablePage({super.key});

  @override
  State<MenuTablePage> createState() => _MenuTablePageState();
}

class _MenuTablePageState extends State<MenuTablePage> {
  List<dynamic> menus = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadMenus();
  }

  Future<void> loadMenus() async {
    try {
      final data = await MenuService.fetchMenus();
      setState(() {
        menus = data;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.orange.shade50, // ✅ พื้นหลังส้มอ่อนทั้งหน้า
      appBar: AppBar(
        title: const Text("📋 รายการเมนู"),
        centerTitle: true,
        backgroundColor: Colors.deepOrange, // ✅ หัว AppBar สีส้มเข้ม
      ),
      body:
          menus.isEmpty
              ? const Center(child: Text("ไม่มีเมนู"))
              : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width,
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: DataTable(
                      columnSpacing: 20,
                      headingRowColor: MaterialStateProperty.all(
                        Colors.orange.shade200, // ✅ หัวตารางส้มอ่อนเข้มกว่า bg
                      ),
                      border: TableBorder(
                        horizontalInside: BorderSide(
                          width: 0.5,
                          color: Colors.green.shade300, // ✅ เส้นเขียวอ่อน
                        ),
                      ),
                      columns: const [
                        DataColumn(label: Text("ภาพ")),
                        DataColumn(label: Text("ชื่อเมนู")),
                        DataColumn(label: Text("ราคา")),
                        DataColumn(label: Text("สถานะ")),
                        DataColumn(label: Text("ประเภท")),
                      ],
                      rows:
                          menus.map((menu) {
                            return DataRow(
                              cells: [
                                DataCell(
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      menu['image'] ?? "",
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(Icons.fastfood),
                                    ),
                                  ),
                                ),
                                DataCell(Text(menu['name'] ?? "")),
                                DataCell(Text("${menu['price']} ฿")),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          (menu['isAvailable'] == true)
                                              ? Colors
                                                  .green // ✅ เขียวถ้าพร้อมขาย
                                              : Colors
                                                  .deepOrange, // ✅ ส้มถ้าไม่พร้อมขาย
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      (menu['isAvailable'] == true)
                                          ? "พร้อมขาย"
                                          : "ไม่พร้อมขาย",
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(Text(menu['type']?['name'] ?? "-")),
                              ],
                            );
                          }).toList(),
                    ),
                  ),
                ),
              ),
    );
  }
}
