import 'package:flutter/material.dart';
import 'package:project_artee/page/cancel_order_page.dart';
import 'package:project_artee/page/food_statuspage.dart';
import 'package:project_artee/page/generate_qr_page.dart';
import 'package:project_artee/page/profile_page.dart';
import 'package:project_artee/views/login_view.dart';
import 'package:project_artee/page/confirm_payment_page.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

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
    // สมมติข้อมูล (จริงๆ จะมาจาก API)
    final String username = "Manatchai";
    final int menuAvailable = 5;
    final int menuOutOfStock = 2;
    final int ordersCreated = 10;
    final int ordersCancelled = 3;
    final int paymentSuccess = 1500;
    final int paymentPending = 300;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant Dashboard'),
        backgroundColor: Colors.lightGreen,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () => _logout(context),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(username),
              accountEmail: const Text("restaurant@example.com"),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: Colors.green),
              ),
              decoration: const BoxDecoration(color: Colors.lightGreen),
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.orange),
              title: const Text("Profile"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.restaurant_menu, color: Colors.teal),
              title: const Text("Change Menu State"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FoodStatusPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.qr_code, color: Colors.deepPurple),
              title: const Text("QR Code"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GenerateQrPage(),
                  ),
                );
                // ไปหน้า QR Code
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel, color: Colors.redAccent),
              title: const Text("Cancel Order"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CancelOrderPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.payment, color: Colors.green),
              title: const Text("Confirm Payment"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ConfirmPaymentPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Section ข้อมูลสรุป
            Card(
              color: Colors.lightGreen.shade50,
              child: ListTile(
                leading: const Icon(
                  Icons.person,
                  color: Colors.green,
                  size: 40,
                ),
                title: Text("ยินดีต้อนรับ, $username"),
                subtitle: const Text("แดชบอร์ดสรุปข้อมูลร้านอาหาร"),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _buildSummaryCard(
                  "เมนูสั่งได้",
                  "$menuAvailable",
                  Colors.green,
                ),
                _buildSummaryCard("เมนูหมด", "$menuOutOfStock", Colors.red),
                _buildSummaryCard("ออเดอร์รวม", "$ordersCreated", Colors.blue),
                _buildSummaryCard("ยกเลิก", "$ordersCancelled", Colors.orange),
                _buildSummaryCard(
                  "ชำระแล้ว",
                  "$paymentSuccess บาท",
                  Colors.teal,
                ),
                _buildSummaryCard(
                  "รอดำเนินการ",
                  "$paymentPending บาท",
                  Colors.purple,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Widget: Summary Card
  Widget _buildSummaryCard(String title, String value, Color color) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 6),
          Text(title, style: TextStyle(fontSize: 14, color: color)),
        ],
      ),
    );
  }
}
