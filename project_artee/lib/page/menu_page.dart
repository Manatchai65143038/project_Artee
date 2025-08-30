import 'package:flutter/material.dart';
import 'package:project_artee/services/menu_api.dart';

// สมบูรณ์

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
      appBar: AppBar(title: const Text("เมนูอาหาร")),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600), // ไม่ยืดเกิน 600
          child:
              menus.isEmpty
                  ? const Center(child: Text("ไม่มีเมนู"))
                  : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: menus.length,
                    itemBuilder: (context, index) {
                      final menu = menus[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          leading: Image.network(
                            menu['image'] ?? "",
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) =>
                                    const Icon(Icons.fastfood),
                          ),
                          title: Text(menu['name'] ?? ""),
                          subtitle: Text("ราคา: ${menu['price']} บาท"),
                          trailing: Switch(
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
