import 'package:flutter/material.dart';
import 'package:project_artee/services/menu_api.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  Future<void> toggleAvailability(int menuID, bool newValue) async {
    try {
      await MenuService.updateAvailability(menuID, newValue);
      setState(() {
        final index = menus.indexWhere((m) => m['menuID'] == menuID);
        if (index != -1) {
          menus[index]['isAvailable'] = newValue;
        }
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
      body:
          menus.isEmpty
              ? const Center(child: Text("ไม่มีเมนู"))
              : ListView.builder(
                itemCount: menus.length,
                itemBuilder: (context, index) {
                  final menu = menus[index];
                  return Card(
                    margin: const EdgeInsets.all(8),
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
    );
  }
}
