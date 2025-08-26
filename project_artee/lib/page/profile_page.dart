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
    'email': 'manatchai@example.com',
    'phone': '081-234-5678',
    'role': 'พนักงานร้านอาหาร',
  };

  bool isEditing = false; // toggle แก้ไข/ดูอย่างเดียว

  // Controller สำหรับ TextField
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController(text: userData['firstName']);
    lastNameController = TextEditingController(text: userData['lastName']);
    emailController = TextEditingController(text: userData['email']);
    phoneController = TextEditingController(text: userData['phone']);
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

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

            // รายละเอียดข้อมูล (ดู/แก้ไข)
            isEditing
                ? _buildEditableForm()
                : Column(
                  children: [
                    _buildInfoCard(
                      Icons.badge,
                      "รหัสพนักงาน",
                      userData['id'] ?? "",
                    ),
                    _buildInfoCard(
                      Icons.email,
                      "อีเมล",
                      userData['email'] ?? "",
                    ),
                    _buildInfoCard(
                      Icons.phone,
                      "เบอร์โทร",
                      userData['phone'] ?? "",
                    ),
                  ],
                ),

            const Spacer(),

            // ปุ่ม แก้ไข/บันทึก
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  if (isEditing) {
                    // ✅ บันทึกข้อมูลเมื่อกด Save
                    userData['firstName'] = firstNameController.text;
                    userData['lastName'] = lastNameController.text;
                    userData['email'] = emailController.text;
                    userData['phone'] = phoneController.text;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("บันทึกข้อมูลเรียบร้อย ✅")),
                    );
                  }
                  isEditing = !isEditing; // toggle state
                });
              },
              icon: Icon(isEditing ? Icons.save : Icons.edit),
              label: Text(isEditing ? "บันทึก" : "แก้ไขโปรไฟล์"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Form สำหรับแก้ไข
  Widget _buildEditableForm() {
    return Column(
      children: [
        TextField(
          controller: firstNameController,
          decoration: const InputDecoration(labelText: "ชื่อจริง"),
        ),
        TextField(
          controller: lastNameController,
          decoration: const InputDecoration(labelText: "นามสกุล"),
        ),
        TextField(
          controller: emailController,
          decoration: const InputDecoration(labelText: "อีเมล"),
        ),
        TextField(
          controller: phoneController,
          decoration: const InputDecoration(labelText: "เบอร์โทร"),
        ),
      ],
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
