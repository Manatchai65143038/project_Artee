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
      setState(() {
        staffs = data;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("โหลดข้อมูลล้มเหลว: $e")));
    }
  }

  void openAddDialog() {
    final nameController = TextEditingController();
    final surnameController = TextEditingController();
    final telController = TextEditingController();
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("เพิ่ม Staff"),
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
                  await StaffService.addStaff(
                    name: nameController.text,
                    surname: surnameController.text,
                    telNo: telController.text,
                    username: usernameController.text,
                    password: passwordController.text,
                  );
                  Navigator.pop(context);
                  loadStaffs();
                },
                child: const Text("บันทึก"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Staff"),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: openAddDialog),
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
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await StaffService.deleteStaff(s['staffID']);
                          loadStaffs();
                        },
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
