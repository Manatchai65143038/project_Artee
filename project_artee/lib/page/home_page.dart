import 'package:flutter/material.dart';
import 'package:project_artee/page/cancel_order_page.dart';
import 'package:project_artee/page/confirm_payment_page.dart';
import 'package:project_artee/page/generate_qr_page.dart';
import 'package:project_artee/page/menu_table_page.dart';
import 'package:project_artee/page/staff_page.dart';
import 'package:project_artee/views/login_view.dart';
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
    "ยกเลิก",
    "ชำระเงิน",
  ];

  final List<IconData> _tabIcons = [
    Icons.home,
    Icons.fastfood,
    Icons.qr_code,
    Icons.person,
    Icons.cancel,
    Icons.payment,
  ];

  final List<Widget> _pages = const [
    MenuTablePage(),
    MenuPage(),
    GenerateQrPage(),
    StaffPage(),
    CancelOrderPage(),
    ConfirmPaymentPage(),
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
                    MaterialPageRoute(builder: (context) => const LoginView()),
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
    final isDesktop = screenWidth > 600; // กำหนด breakpoint

    return Scaffold(
      appBar: AppBar(
        title: const Text("Restaurant Artee"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
        bottom:
            isDesktop
                ? null
                : TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  tabs: List.generate(
                    _tabTitles.length,
                    (index) => Tab(
                      text: _tabTitles[index],
                      icon: Icon(_tabIcons[index]),
                    ),
                  ),
                ),
      ),
      body:
          isDesktop
              ? Row(
                children: [
                  NavigationRail(
                    selectedIndex: _tabController.index,
                    onDestinationSelected:
                        (index) => setState(() {
                          _tabController.index = index;
                        }),
                    labelType: NavigationRailLabelType.all,
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
                    child: TabBarView(
                      controller: _tabController,
                      children: _pages,
                    ),
                  ),
                ],
              )
              : TabBarView(controller: _tabController, children: _pages),
    );
  }
}
