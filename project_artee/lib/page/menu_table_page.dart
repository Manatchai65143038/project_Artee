import 'package:flutter/material.dart';
import 'package:project_artee/services/menu_api.dart';

// 📋 แสดงตารางเมนู
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
      appBar: AppBar(title: const Text("📋 รายการเมนู"), centerTitle: true),
      body:
          menus.isEmpty
              ? const Center(child: Text("ไม่มีเมนู"))
              : SingleChildScrollView(
                scrollDirection: Axis.horizontal, // เลื่อนในแนวนอน
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth:
                        MediaQuery.of(context).size.width, // ให้กว้างเท่าหน้าจอ
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical, // เลื่อนในแนวตั้ง
                    child: DataTable(
                      columnSpacing: 20,
                      headingRowColor: MaterialStateProperty.all(
                        Colors.grey.shade200,
                      ),
                      border: TableBorder(
                        horizontalInside: BorderSide(
                          width: 0.5,
                          color: Colors.grey.shade300,
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
                                              ? Colors.green
                                              : Colors.red,
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
