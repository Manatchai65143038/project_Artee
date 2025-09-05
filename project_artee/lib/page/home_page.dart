import 'package:flutter/material.dart';
import 'package:project_artee/page/cancel_order_page.dart';
import 'package:project_artee/page/confirm_payment_page.dart';
import 'package:project_artee/page/detail_order_page.dart';
import 'package:project_artee/page/generate_qr_page.dart';
import 'package:project_artee/page/login_page.dart';
import 'package:project_artee/page/menu_table_page.dart';
import 'package:project_artee/page/serve_order_page.dart';
import 'package:project_artee/page/staff_page.dart';
import 'menu_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  final List<String> _tabTitles = [
    "หน้าหลัก",
    "เมนู",
    "QR Code",
    "โปรไฟล์",
    "รับออเดอร์",
    "เสิร์ฟอาหาร",
  ];

  final List<IconData> _tabIcons = [
    Icons.home,
    Icons.fastfood,
    Icons.qr_code,
    Icons.person,
    Icons.fastfood,
    Icons.restaurant,
    Icons.payment,
  ];

  final List<Widget> _pages = const [
    MenuTablePage(),
    MenuPage(),
    GenerateQrPage(),
    StaffPage(),
    DetailOrderPage(),
    ServeOrderPage(),
    CancelOrderPage(),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _pages.length, vsync: this);
  }

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Logout'),
            content: const Text('คุณต้องการออกจากระบบหรือไม่?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('ยกเลิก'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                child: const Text('ตกลง'),
              ),
            ],
          ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 600;

    const Color primaryGreen = Color(0xFF4CAF50); // สีเขียวหลัก
    const Color secondaryOrange = Color(0xFFFF9800); // สีส้มรอง

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.9),
        elevation: 3,
        title: const Text(
          "Restaurant Atree",
          style: TextStyle(
            color: primaryGreen,
            fontWeight: FontWeight.bold,
          ), // เขียว
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: primaryGreen),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
            color: primaryGreen,
          ),
        ],
        bottom:
            isDesktop
                ? null
                : TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  indicatorColor: secondaryOrange,
                  labelColor: secondaryOrange,
                  unselectedLabelColor: primaryGreen.withOpacity(0.7),
                  tabs: List.generate(
                    _tabTitles.length,
                    (index) => Tab(
                      text: _tabTitles[index],
                      icon: Icon(_tabIcons[index]),
                    ),
                  ),
                ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFE8F5E9),
              Color(0xFFFFF3E0),
            ], // เขียวอ่อน -> ส้มอ่อน
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child:
              isDesktop
                  ? Row(
                    children: [
                      NavigationRail(
                        backgroundColor: Colors.white.withOpacity(0.95),
                        selectedIndex: _tabController.index,
                        onDestinationSelected:
                            (index) => setState(() {
                              _tabController.index = index;
                            }),
                        labelType: NavigationRailLabelType.all,
                        selectedIconTheme: const IconThemeData(
                          color: secondaryOrange,
                        ),
                        selectedLabelTextStyle: const TextStyle(
                          color: secondaryOrange,
                          fontWeight: FontWeight.bold,
                        ),
                        unselectedIconTheme: const IconThemeData(
                          color: primaryGreen,
                        ),
                        destinations: List.generate(
                          _tabTitles.length,
                          (index) => NavigationRailDestination(
                            icon: Icon(_tabIcons[index]),
                            label: Text(_tabTitles[index]),
                          ),
                        ),
                      ),
                      const VerticalDivider(thickness: 1, width: 1),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: TabBarView(
                            controller: _tabController,
                            children: _pages,
                          ),
                        ),
                      ),
                    ],
                  )
                  : Padding(
                    padding: const EdgeInsets.all(12),
                    child: TabBarView(
                      controller: _tabController,
                      children: _pages,
                    ),
                  ),
        ),
      ),
    );
  }
}
