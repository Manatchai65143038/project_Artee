import 'package:flutter/material.dart';
import 'package:project_artee/page/publish.dart';
import 'package:project_artee/views/login_view.dart';
import 'menu_page.dart'; // import หน้าเมนูที่คุณเขียนไว้

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // กำหนดหน้าที่จะใช้ใน HomePage (5 หน้า)
  final List<Widget> _pages = [
    const Center(child: Text("👤 หน้าหลัก", style: TextStyle(fontSize: 20))),
    const MenuPage(), // หน้าเมนู
    const Center(child: Text("👤 โปรไฟล์", style: TextStyle(fontSize: 20))),
    const Center(child: Text("🔔 ยกเลิก", style: TextStyle(fontSize: 20))),
    const Center(child: Text("⚙️ การตั้งค่า", style: TextStyle(fontSize: 20))),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
                onPressed: () => Navigator.of(context).pop(), // ยกเลิก
                child: const Text('ยกเลิก'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // ปิด dialog ก่อน
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
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // ✅ ต้องใส่ถ้าเกิน 3 item
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "หนเาหลัก"),
          BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: "เมนู"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "โปรไฟล์"),
          BottomNavigationBarItem(icon: Icon(Icons.cancel), label: "ยกเลิก"),
          BottomNavigationBarItem(icon: Icon(Icons.payment), label: "ชำระเงิน"),
        ],
      ),
    );
  }
}
