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

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const MenuTablePage(), // เปลี่ยนเป็น MenuTablePage
    const MenuPage(), // เปลี่ยนเป็น MenuPage
    const GenerateQrPage(), // เปลี่ยนเป็น GenerateQrPage
    const StaffPage(), // เปลี่ยนเป็น ProfilePage
    const CancelOrderPage(), // เปลี่ยนเป็น CancelOrderPage
    const ConfirmPaymentPage(), // เปลี่ยนเป็น ConfirmPaymentPage
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // ออกจากระบบ
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

  // ออกจากระบบ
  @override
  Widget build(BuildContext context) {
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
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onItemTapped,
            labelType: NavigationRailLabelType.all, // โชว์ label ตลอด
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.home),
                label: Text("หน้าหลัก"),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.fastfood),
                label: Text("เมนู"),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.qr_code),
                label: Text("QR Code"),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.person),
                label: Text("โปรไฟล์"),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.cancel),
                label: Text("ยกเลิก"),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.payment),
                label: Text("ชำระเงิน"),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1), // เส้นแบ่ง
          Expanded(
            child: _pages[_selectedIndex], // เนื้อหาหน้า
          ),
        ],
      ),
    );
  }
}
