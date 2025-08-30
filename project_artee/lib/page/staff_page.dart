import 'package:flutter/material.dart';
import 'package:project_artee/services/staff_api.dart';

// สมบูรณ์

class StaffPage extends StatefulWidget {
  const StaffPage({super.key});

  @override
  State<StaffPage> createState() => _StaffPageState();
}

class _StaffPageState extends State<StaffPage> {
  List<dynamic> staffs = [];
  bool loading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadStaffs();
  }

  /// โหลดข้อมูล Staff
  Future<void> loadStaffs() async {
    setState(() {
      loading = true;
      errorMessage = null;
    });

    try {
      final data = await StaffService.fetchStaffs();
      setState(() {
        staffs = data;
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
        errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Staff Management")),
      body:
          loading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage != null
              ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(errorMessage!, textAlign: TextAlign.center),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: loadStaffs,
                      child: const Text("ลองใหม่"),
                    ),
                  ],
                ),
              )
              : staffs.isEmpty
              ? const Center(child: Text("ไม่มีข้อมูลพนักงาน"))
              : ListView.builder(
                itemCount: staffs.length,
                itemBuilder: (context, index) {
                  final staff = staffs[index];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          staff['image'] != null && staff['image'] != ""
                              ? staff['image']
                              : "https://via.placeholder.com/150",
                        ),
                      ),
                      title: Text("${staff['name']} ${staff['surname']}"),
                      subtitle: Text(staff['email']),
                    ),
                  );
                },
              ),
      // ลบ FloatingActionButton ออก
    );
  }
}
