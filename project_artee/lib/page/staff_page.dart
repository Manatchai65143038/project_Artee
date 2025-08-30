import 'package:flutter/material.dart';
import 'package:project_artee/services/staff_api.dart';

class StaffTablePage extends StatefulWidget {
  const StaffTablePage({super.key});

  @override
  State<StaffTablePage> createState() => _StaffTablePageState();
}

class _StaffTablePageState extends State<StaffTablePage> {
  List<dynamic> staffs = [];
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
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.receipt_long),
            SizedBox(width: 8),
            Text(" รายการพนักงาน"),
          ],
        ),
      ),
      body:
          loading
              ? const Center(child: CircularProgressIndicator())
              : staffs.isEmpty
              ? const Center(child: Text("ไม่มีข้อมูลพนักงาน"))
              : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 20,
                  headingRowColor: MaterialStateProperty.all(
                    Colors.grey.shade200,
                  ),
                  border: TableBorder(
                    horizontalInside: BorderSide(
                      width: 0.5,
                      color: Colors.grey.shade300,
                    ),
                  ),
                  columns: const [
                    DataColumn(label: Text("รูป")),
                    DataColumn(label: Text("รหัสพนักงาน")),
                    DataColumn(label: Text("ชื่อ")),
                    DataColumn(label: Text("นามสกุล")),
                    DataColumn(label: Text("เบอร์โทร")),
                    DataColumn(label: Text("อีเมล")),
                  ],
                  rows:
                      staffs.map((staff) {
                        return DataRow(
                          cells: [
                            DataCell(
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                  staff['image'] ?? "",
                                ),
                                radius: 25,
                                onBackgroundImageError:
                                    (_, __) => const Icon(Icons.person),
                              ),
                            ),
                            DataCell(Text(staff['staffID'] ?? "")),
                            DataCell(Text(staff['name'] ?? "")),
                            DataCell(Text(staff['surname'] ?? "")),
                            DataCell(Text(staff['telNo'] ?? "")),
                            DataCell(Text(staff['email'] ?? "")),
                          ],
                        );
                      }).toList(),
                ),
              ),
    );
  }
}
