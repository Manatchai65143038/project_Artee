import 'package:flutter/material.dart';
import 'package:project_artee/services/menu_api.dart';

class MenuTablePage extends StatefulWidget {
  const MenuTablePage({super.key});

  @override
  State<MenuTablePage> createState() => _MenuTablePageState();
}

class _MenuTablePageState extends State<MenuTablePage>
    with TickerProviderStateMixin {
  List<dynamic> menus = [];
  bool loading = true;
  String? selectedType;

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
      ).showSnackBar(SnackBar(content: Text("เกิดข้อผิดพลาด: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Colors.deepOrange),
        ),
      );
    }

    final types = menus.map((m) => m['type']?['name']).toSet().toList();
    final filteredMenus =
        selectedType == null
            ? menus
            : menus.where((m) => m['type']?['name'] == selectedType).toList();

    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        title: const Text(
          "รายการเมนูอาหาร",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        elevation: 6, // เพิ่มความลึกให้ shadow
        backgroundColor: Colors.deepOrange.shade700,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20), // โค้งด้านล่างของ AppBar
          ),
        ),
        shadowColor: Colors.deepOrangeAccent.withOpacity(0.4),
      ),
      body: Column(
        children: [
          // 🌿 Dropdown Filter
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
                      ...types.map(
                        (type) => DropdownMenuItem<String?>(
                          value: type,
                          child: Text(
                            type ?? "-",
                            style: const TextStyle(fontWeight: FontWeight.w500),
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
          // 📋 ตารางเมนู + Animation
          Expanded(
            child:
                filteredMenus.isEmpty
                    ? const Center(
                      child: Text(
                        "ไม่พบเมนูในประเภทนี้",
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    )
                    : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: MediaQuery.of(context).size.width,
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: DataTable(
                            columnSpacing: 24,
                            headingRowColor: MaterialStateProperty.all(
                              Colors.green.shade200,
                            ),
                            headingTextStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            dataRowHeight: 70,
                            dividerThickness: 1,
                            border: TableBorder.all(
                              color: Colors.green.shade100,
                              width: 1,
                            ),
                            columns: const [
                              DataColumn(label: Text("ภาพ")),
                              DataColumn(label: Text("ชื่อเมนู")),
                              DataColumn(label: Text("ราคา")),
                              DataColumn(label: Text("สถานะ")),
                              DataColumn(label: Text("ประเภท")),
                            ],
                            rows: List.generate(filteredMenus.length, (index) {
                              final menu = filteredMenus[index];
                              return DataRow(
                                cells: [
                                  DataCell(
                                    TweenAnimationBuilder<double>(
                                      tween: Tween(begin: 50, end: 0),
                                      duration: Duration(
                                        milliseconds: 400 + (index * 100),
                                      ),
                                      builder: (context, value, child) {
                                        return Transform.translate(
                                          offset: Offset(value, 0),
                                          child: Opacity(
                                            opacity: 1 - (value / 50),
                                            child: child,
                                          ),
                                        );
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          menu['image'] ?? "",
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stack) =>
                                                  Container(
                                                    width: 60,
                                                    height: 60,
                                                    color: Colors.green.shade50,
                                                    child: const Icon(
                                                      Icons.fastfood,
                                                      color: Colors.deepOrange,
                                                    ),
                                                  ),
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
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            menu['isAvailable'] == true
                                                ? Colors.green
                                                : Colors.deepOrange,
                                        borderRadius: BorderRadius.circular(14),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.1,
                                            ),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        menu['isAvailable'] == true
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
                                    Text(
                                      menu['type']?['name'] ?? "-",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
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
