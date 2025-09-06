import 'package:flutter/material.dart';
import 'package:project_artee/services/staff_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StaffPage extends StatefulWidget {
  const StaffPage({super.key});

  @override
  State<StaffPage> createState() => _StaffPageState();
}

class _StaffPageState extends State<StaffPage> {
  List<dynamic> staffs = [];
  bool loading = true;
  String? errorMessage;
  String? myStaffID; // ✅ เก็บ staffID ที่ login

  @override
  void initState() {
    super.initState();
    loadStaffs();
  }

  /// โหลดข้อมูล Staff + Filter ตาม staffID
  Future<void> loadStaffs() async {
    if (!mounted) return;
    setState(() {
      loading = true;
      errorMessage = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      myStaffID = prefs.getString("staffID");

      final data = await StaffService.fetchStaffs();

      List<dynamic> filtered = data;
      if (myStaffID != null && myStaffID!.isNotEmpty) {
        filtered =
            data.where((s) => s["staffID"].toString() == myStaffID).toList();
      }

      if (!mounted) return;
      setState(() {
        staffs = filtered;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        loading = false;
        errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        title: const Text(
          "Staff Management",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
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

  Widget _buildErrorWidget() => Center(child: Text(errorMessage ?? "Error"));
  Widget _buildEmptyWidget() => const Center(child: Text("ไม่มีข้อมูลพนักงาน"));

  Widget _buildStaffList() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
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
            subtitle: Text(staff['email'] ?? "-"),
          ),
        );
      },
    );
  }
}
