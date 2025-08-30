import 'package:flutter/material.dart';
import 'package:project_artee/services/menu_api.dart';

// ✅ โทนส้ม + เขียว สดชื่น
class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
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

    return Scaffold(
      backgroundColor: Colors.orange[50], // ✅ พื้นหลังส้มอ่อน
      appBar: AppBar(
        title: const Text("เมนูอาหาร"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.deepOrange, // ✅ ส้มเข้ม
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child:
              menus.isEmpty
                  ? const Center(
                    child: Text(
                      "ไม่มีเมนู",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                  : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: menus.length,
                    itemBuilder: (context, index) {
                      final menu = menus[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 5,
                        shadowColor: Colors.green.withOpacity(
                          0.3,
                        ), // ✅ เงาเขียว
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
                                  (context, error, stackTrace) => Container(
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
                              color: Colors.deepOrange, // ✅ หัวข้อส้ม
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              "ราคา: ${menu['price']} บาท",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.green[700], // ✅ เขียวเข้ม
                              ),
                            ),
                          ),
                          trailing: Switch(
                            activeColor: Colors.green, // ✅ Switch สีเขียว
                            value: menu['isAvailable'] == true,
                            onChanged:
                                (value) =>
                                    toggleAvailability(menu['menuID'], value),
                          ),
                        ),
                      );
                    },
                  ),
        ),
      ),
    );
  }
}
