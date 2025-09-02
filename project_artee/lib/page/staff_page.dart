import 'package:flutter/material.dart';
import 'package:project_artee/services/staff_api.dart';

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
      backgroundColor: Colors.orange.shade50, // ✅ พื้นหลังส้มอ่อน
      appBar: AppBar(
        title: const Text("Staff Management"),
        centerTitle: true,
        backgroundColor: Colors.deepOrange, // ✅ หัวส้มเข้ม
      ),
      body:
          loading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage != null
              ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Colors.deepOrange,
                      size: 50,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.black87),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: loadStaffs,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green, // ✅ ปุ่มเขียว
                      ),
                      icon: const Icon(Icons.refresh),
                      label: const Text("ลองใหม่"),
                    ),
                  ],
                ),
              )
              : staffs.isEmpty
              ? const Center(child: Text("ไม่มีข้อมูลพนักงาน"))
              : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: staffs.length,
                itemBuilder: (context, index) {
                  final staff = staffs[index];
                  return Card(
                    color: Colors.white,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 28,
                        backgroundColor:
                            Colors.green.shade200, // ✅ กรอบเขียวอ่อน
                        child: CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(
                            staff['image'] != null && staff['image'] != ""
                                ? staff['image']
                                : "https://via.placeholder.com/150",
                          ),
                        ),
                      ),
                      title: Text(
                        "${staff['name']} ${staff['surname']}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange,
                        ),
                      ),
                      subtitle: Text(
                        staff['email'],
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
