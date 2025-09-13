import 'package:flutter/material.dart';
import 'package:project_artee/services/menu_api.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> with TickerProviderStateMixin {
  List<dynamic> menus = [];
  bool loading = true;
  String? selectedType;

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    loadMenus();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> loadMenus() async {
    try {
      final data = await MenuService.fetchMenus();
      if (!mounted) return;
      setState(() {
        menus = data;
        loading = false;
      });
      _controller.forward(); // start animation
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
    if (loading) return const Center(child: CircularProgressIndicator());

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
              // Dropdown Filter
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
                              type,
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

              // Animated Menu List
              Expanded(
                child:
                    filteredMenus.isEmpty
                        ? const Center(
                          child: Text(
                            "ไม่มีเมนู",
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        )
                        : AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          child: ListView.builder(
                            key: ValueKey(selectedType),
                            padding: const EdgeInsets.all(12),
                            itemCount: filteredMenus.length,
                            itemBuilder: (context, index) {
                              final menu = filteredMenus[index];

                              final animation = Tween<Offset>(
                                begin: const Offset(0, 0.2),
                                end: Offset.zero,
                              ).animate(
                                CurvedAnimation(
                                  parent: _controller,
                                  curve: Curves.easeOut,
                                ),
                              );

                              return SlideTransition(
                                position: animation,
                                child: FadeTransition(
                                  opacity: _controller,
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          menu['isAvailable']
                                              ? Colors.green[50]
                                              : Colors.orange[50],
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.green.withOpacity(0.1),
                                          blurRadius: 6,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
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
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
