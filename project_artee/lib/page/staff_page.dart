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
      if (!mounted) return;
      setState(() {
        staffs = List<Map<String, dynamic>>.from(data);
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

  @override
  Widget build(BuildContext context) {
    if (loading) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      appBar: AppBar(title: const Text("Staff")),
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
                    ),
                  );
                },
              ),
    );
  }
}
