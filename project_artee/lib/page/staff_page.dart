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
    if (!mounted) return; // ✅ กัน setState หลัง dispose
    setState(() {
      loading = true;
      errorMessage = null;
    });

    try {
      final data = await StaffService.fetchStaffs();

      if (!mounted) return; // ✅ กัน setState หลัง dispose
      setState(() {
        staffs = data;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return; // ✅ กัน setState หลัง dispose
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
        title: const Text(
          "Staff Management",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepOrange, // ✅ หัวส้มเข้ม
        elevation: 4,
      ),
      body:
          loading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage != null
              ? _buildErrorWidget()
              : staffs.isEmpty
              ? _buildEmptyWidget()
              : _buildStaffList(),
    );
  }

  /// แสดง error
  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade400, size: 60),
          const SizedBox(height: 12),
          Text(
            errorMessage!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black87, fontSize: 16),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: loadStaffs,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            icon: const Icon(Icons.refresh, color: Colors.white),
            label: const Text("ลองใหม่", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  /// กรณีไม่มีข้อมูล
  Widget _buildEmptyWidget() {
    return const Center(
      child: Text(
        "ไม่มีข้อมูลพนักงาน",
        style: TextStyle(fontSize: 18, color: Colors.black54),
      ),
    );
  }

  /// แสดง List ของ Staff
  Widget _buildStaffList() {
    return ListView.builder(
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
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: CircleAvatar(
              radius: 28,
              backgroundColor: Colors.green.shade200, // ✅ กรอบเขียวอ่อน
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
                fontSize: 16,
              ),
            ),
            subtitle: Text(
              staff['email'] ?? "-",
              style: const TextStyle(color: Colors.black54, fontSize: 14),
            ),
          ),
        );
      },
    );
  }
}
