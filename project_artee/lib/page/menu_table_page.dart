import 'package:flutter/material.dart';
import 'package:project_artee/services/menu_api.dart';

class MenuTablePage extends StatefulWidget {
  const MenuTablePage({super.key});

  @override
  State<MenuTablePage> createState() => _MenuTablePageState();
}

class _MenuTablePageState extends State<MenuTablePage> {
  List<dynamic> menus = [];
  bool loading = true;

  String? selectedType; // ✅ ฟิลเตอร์ประเภท

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

    // ✅ ดึงประเภทเมนูทั้งหมดแบบไม่ซ้ำ
    final types = menus.map((m) => m['type']?['name']).toSet().toList();

    // ✅ กรองเมนูตามประเภท
    final filteredMenus =
        selectedType == null
            ? menus
            : menus.where((m) => m['type']?['name'] == selectedType).toList();

    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        title: const Text(
          "รายการเมนูอาหาร",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
        elevation: 4,
      ),
      body: Column(
        children: [
          // 🥗 Dropdown Filter
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.green, width: 1.2),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: DropdownButton<String>(
                  underline: const SizedBox(),
                  isExpanded: true,
                  hint: const Text("เลือกประเภทอาหาร"),
                  value: selectedType,
                  items: [
                    const DropdownMenuItem(value: null, child: Text("ทั้งหมด")),
                    ...types.map(
                      (type) => DropdownMenuItem(
                        value: type,
                        child: Text(type ?? "-"),
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

          // 📋 ตารางเมนู
          Expanded(
            child:
                filteredMenus.isEmpty
                    ? const Center(child: Text("ไม่พบเมนูในประเภทนี้"))
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
                              Colors.green.shade200,
                            ),
                            dataRowColor: MaterialStateProperty.resolveWith(
                              (states) =>
                                  states.contains(MaterialState.selected)
                                      ? Colors.orange.shade100
                                      : Colors.white,
                            ),
                            border: TableBorder.all(
                              color: Colors.green.shade200,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            columns: const [
                              DataColumn(label: Text("ภาพ")),
                              DataColumn(label: Text("ชื่อเมนู")),
                              DataColumn(label: Text("ราคา")),
                              DataColumn(label: Text("สถานะ")),
                              DataColumn(label: Text("ประเภท")),
                            ],
                            rows:
                                filteredMenus.map((menu) {
                                  return DataRow(
                                    cells: [
                                      DataCell(
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          child: Image.network(
                                            menu['image'] ?? "",
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stack) =>
                                                    const Icon(
                                                      Icons.fastfood,
                                                      color: Colors.deepOrange,
                                                    ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          menu['name'] ?? "",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.deepOrange,
                                          ),
                                        ),
                                      ),
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
                                                    : Colors.deepOrange,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Text(
                                            (menu['isAvailable'] == true)
                                                ? "พร้อมขาย"
                                                : "ไม่พร้อมขาย",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Text(menu['type']?['name'] ?? "-"),
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
