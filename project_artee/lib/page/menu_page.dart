import 'package:flutter/material.dart';
import 'package:project_artee/services/menu_api.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
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
      if (!mounted) return;
      setState(() {
        menus = data;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => loading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  Future<void> toggleAvailability(int menuID, bool newValue) async {
    try {
      await MenuService.updateAvailability(menuID, newValue);
      if (!mounted) return;
      setState(() {
        final index = menus.indexWhere((m) => m['menuID'] == menuID);
        if (index != -1) menus[index]['isAvailable'] = newValue;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Updated menu #$menuID")));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Update failed: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final menuTypes =
        menus.map((m) => m['type']?['name'] ?? "").toSet().toList();

    final filteredMenus =
        selectedType == null
            ? menus
            : menus.where((m) => m['type']?['name'] == selectedType).toList();

    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        title: const Text(
          "เมนูอาหาร",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.deepOrange,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            children: [
              // 🥗 ฟิลเตอร์ประเภทอาหาร
              Padding(
                padding: const EdgeInsets.all(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.green.shade400,
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.15),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: DropdownButton<String?>(
                    isExpanded: true,
                    underline: const SizedBox(),
                    hint: const Text("เลือกประเภทอาหาร"),
                    value: selectedType,
                    items: [
                      const DropdownMenuItem<String?>(
                        value: null,
                        child: Text("ทั้งหมด"),
                      ),
                      ...menuTypes.map(
                        (type) => DropdownMenuItem<String?>(
                          value: type,
                          child: Text(type),
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

              // 📋 รายการเมนู
              Expanded(
                child:
                    filteredMenus.isEmpty
                        ? const Center(
                          child: Text(
                            "ไม่มีเมนู",
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        )
                        : ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: filteredMenus.length,
                          itemBuilder: (context, index) {
                            final menu = filteredMenus[index];
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 6,
                              shadowColor: Colors.green.withOpacity(0.25),
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(12),
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    menu['image'] ?? "",
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                              width: 70,
                                              height: 70,
                                              color: Colors.orange[100],
                                              child: const Icon(
                                                Icons.fastfood,
                                                color: Colors.green,
                                                size: 30,
                                              ),
                                            ),
                                  ),
                                ),
                                title: Text(
                                  menu['name'] ?? "",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepOrange,
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    "ราคา: ${menu['price']} บาท",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                                trailing: Switch(
                                  activeColor: Colors.green,
                                  value: menu['isAvailable'] == true,
                                  onChanged:
                                      (value) => toggleAvailability(
                                        menu['menuID'],
                                        value,
                                      ),
                                ),
                              ),
                            );
                          },
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
