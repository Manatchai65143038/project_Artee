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
  String? myStaffID;

  @override
  void initState() {
    super.initState();
    loadStaffs();
  }

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
              : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    for (var staff in staffs)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 24,
                          ),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 4,
                            shadowColor: Colors.deepOrangeAccent.withOpacity(
                              0.3,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 20,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 50,
                                    backgroundImage: NetworkImage(
                                      staff['image'] != null &&
                                              staff['image'] != ""
                                          ? staff['image']
                                          : "https://via.placeholder.com/150",
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    "${staff['name']} ${staff['surname']}",
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "${staff['email'] ?? "-"}",
                                    style: const TextStyle(fontSize: 15),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "${staff['telNo'] ?? "-"}",
                                    style: const TextStyle(fontSize: 15),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
    );
  }

  Widget _buildErrorWidget() =>
      Center(child: Text(errorMessage ?? "Error loading staff"));
  Widget _buildEmptyWidget() => const Center(child: Text("ไม่พบข้อมูลพนักงาน"));
}
