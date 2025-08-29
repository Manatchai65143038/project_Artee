import 'package:flutter/material.dart';
import 'package:project_artee/services/staff_api.dart';

class StaffPage extends StatefulWidget {
  const StaffPage({super.key});

  @override
  State<StaffPage> createState() => _StaffPageState();
}

class _StaffPageState extends State<StaffPage> {
  List<Map<String, dynamic>> staffs = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadStaffs();
  }

  Future<void> loadStaffs() async {
    try {
      final data = await StaffService.fetchStaffs();
      if (!mounted) return; // ✅ ป้องกัน setState หลัง dispose
      setState(() {
        staffs = data;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => loading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("โหลดข้อมูลล้มเหลว: $e")));
    }
  }

  // เพิ่ม/แก้ไข Staff
  void openStaffDialog({Map<String, dynamic>? staff}) {
    final nameController = TextEditingController(text: staff?['name']);
    final surnameController = TextEditingController(text: staff?['surname']);
    final telController = TextEditingController(text: staff?['telNo']);
    final usernameController = TextEditingController(text: staff?['username']);
    final passwordController = TextEditingController(text: staff?['password']);

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(staff == null ? "เพิ่ม Staff" : "แก้ไข Staff"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: "ชื่อ"),
                  ),
                  TextField(
                    controller: surnameController,
                    decoration: const InputDecoration(labelText: "นามสกุล"),
                  ),
                  TextField(
                    controller: telController,
                    decoration: const InputDecoration(labelText: "เบอร์โทร"),
                  ),
                  TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(labelText: "Username"),
                  ),
                  TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(labelText: "Password"),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("ยกเลิก"),
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    if (staff == null) {
                      // เพิ่ม Staff
                      await StaffService.addStaff(
                        name: nameController.text,
                        surname: surnameController.text,
                        telNo: telController.text,
                        username: usernameController.text,
                        password: passwordController.text,
                      );
                    } else {
                      // แก้ไข Staff
                      await StaffService.updateStaff(staff['staffID'], {
                        "name": nameController.text,
                        "surname": surnameController.text,
                        "telNo": telController.text,
                        "username": usernameController.text,
                        "password": passwordController.text,
                      });
                    }
                    if (!mounted) return;
                    Navigator.pop(context);
                    loadStaffs();
                  } catch (e) {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("เกิดข้อผิดพลาด: $e")),
                    );
                  }
                },
                child: const Text("บันทึก"),
              ),
            ],
          ),
    );
  }

  // ลบ Staff
  void deleteStaff(int id) async {
    try {
      await StaffService.deleteStaff(id);
      if (!mounted) return;
      loadStaffs();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("ลบ Staff ไม่สำเร็จ: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Staff"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => openStaffDialog(),
          ),
        ],
      ),
      body:
          staffs.isEmpty
              ? const Center(child: Text("ยังไม่มี Staff"))
              : ListView.builder(
                itemCount: staffs.length,
                itemBuilder: (context, index) {
                  final s = staffs[index];
                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      title: Text("${s['name']} ${s['surname']}"),
                      subtitle: Text(
                        "Username: ${s['username']} | Tel: ${s['telNo']}",
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => openStaffDialog(staff: s),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => deleteStaff(s['staffID']),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
