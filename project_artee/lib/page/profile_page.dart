import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // ✅ จำลองข้อมูลที่ดึงมาจาก API หรือ Login
  Map<String, String> userData = {
    'id': 'EMP001',
    'firstName': 'Manatchai',
    'lastName': 'JACK',
    'phone': '081-234-5678',
    'role': 'พนักงานร้านอาหาร',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('โปรไฟล์ของฉัน'),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // รูปโปรไฟล์
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.green,
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 16),

            Text(
              "${userData['firstName']} ${userData['lastName']}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              userData['role'] ?? '',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 20),

            // รายละเอียดข้อมูล
            _buildInfoCard(Icons.badge, "รหัสพนักงาน", userData['id'] ?? ""),
            _buildInfoCard(Icons.phone, "เบอร์โทร", userData['phone'] ?? ""),
          ],
        ),
      ),
    );
  }

  // ✅ Widget แสดงข้อมูล
  Widget _buildInfoCard(IconData icon, String title, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.green),
        title: Text(title),
        subtitle: Text(value, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}
