import 'package:flutter/material.dart';
import 'package:project_artee/services/staff_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';

class LogoutPage extends StatefulWidget {
  const LogoutPage({super.key});

  @override
  State<LogoutPage> createState() => _LogoutPageState();
}

class _LogoutPageState extends State<LogoutPage> {
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

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Logout'),
            content: const Text('คุณต้องการออกจากระบบหรือไม่?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('ยกเลิก'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _logout(context);
                },
                child: const Text('ตกลง'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        title: const Text(
          "ข้อมูลพนักงาน",
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
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 24,
                        ),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 8,
                          shadowColor: Colors.deepOrangeAccent.withOpacity(0.5),
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 50, // เพิ่มขนาดรูป
                                  backgroundImage: NetworkImage(
                                    staff['image'] != null &&
                                            staff['image'] != ""
                                        ? staff['image']
                                        : "https://via.placeholder.com/150",
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  "${staff['name']} ${staff['surname']}",
                                  style: const TextStyle(
                                    fontSize: 20, // ตัวใหญ่ขึ้น
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "${staff['email'] ?? "-"}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black87,
                                  ),
                                ),
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
                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: SizedBox(
                        width: double.infinity,
                        child: Center(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                vertical: 18,
                                horizontal: 24,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            icon: const Icon(Icons.logout, size: 26),
                            label: const Text(
                              "ออกจากระบบ",
                              style: TextStyle(fontSize: 20),
                            ),
                            onPressed: () => _showLogoutDialog(context),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
    );
  }

  Widget _buildErrorWidget() =>
      Center(child: Text(errorMessage ?? "Error loading staff"));
  Widget _buildEmptyWidget() => const Center(child: Text("ไม่พบข้อมูลพนักงาน"));
}
