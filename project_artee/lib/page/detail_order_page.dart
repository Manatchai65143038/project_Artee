import 'package:flutter/material.dart';
import 'package:project_artee/services/detail_order_api.dart';
import 'package:project_artee/services/track_order_api.dart';

class DetailOrderPage extends StatefulWidget {
  const DetailOrderPage({super.key});

  @override
  State<DetailOrderPage> createState() => _DetailOrderPageState();
}

class _DetailOrderPageState extends State<DetailOrderPage> {
  late Future<List<DetailOrder>> futureOrders;
  late Future<List<OrderTrack>> futureTracks;

  // เก็บ trackState ที่เลือกใหม่
  Map<int, String> selectedTracks = {};

  @override
  void initState() {
    super.initState();
    futureOrders = DetailOrderService.fetchDetailOrders();
    futureTracks = OrderTrackService.fetchOrderTracks();
  }

  // อัปเดต track ของแต่ละ order ทีละอัน
  void _updateTrack(DetailOrder order, OrderTrack newTrack) async {
    bool success = await DetailOrderService.updateTrack(
      order.detailNo,
      newTrack.trackOrderID,
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "อัปเดตสถานะ ${order.detailNo} → ${newTrack.trackStateName} สำเร็จ",
          ),
        ),
      );
      setState(() {
        futureOrders = DetailOrderService.fetchDetailOrders();
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("อัปเดตไม่สำเร็จ")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ออเดอร์ของลูกค้า")),
      body: FutureBuilder<List<DetailOrder>>(
        future: futureOrders,
        builder: (context, snapshotOrders) {
          if (snapshotOrders.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshotOrders.hasError) {
            return Center(
              child: Text("เกิดข้อผิดพลาด: ${snapshotOrders.error}"),
            );
          } else if (!snapshotOrders.hasData || snapshotOrders.data!.isEmpty) {
            return const Center(child: Text("ยังไม่มีการสั่งอาหาร"));
          }

          final orders = snapshotOrders.data!;

          return FutureBuilder<List<OrderTrack>>(
            future: futureTracks,
            builder: (context, snapshotTracks) {
              if (snapshotTracks.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshotTracks.hasError) {
                return Center(
                  child: Text("เกิดข้อผิดพลาด: ${snapshotTracks.error}"),
                );
              } else if (!snapshotTracks.hasData ||
                  snapshotTracks.data!.isEmpty) {
                return const Center(child: Text("ไม่มีข้อมูลสถานะ"));
              }

              final tracks = snapshotTracks.data!;

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal, // เลื่อนแนวนอน
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width,
                  ),
                  child: DataTable(
                    columnSpacing: 12,
                    headingRowHeight: 40,
                    // ignore: deprecated_member_use
                    dataRowHeight: 60,
                    columns: const [
                      DataColumn(label: Text("ลำดับ")),
                      DataColumn(label: Text("เมนู")),
                      DataColumn(label: Text("ประเภท")),
                      DataColumn(label: Text("จำนวน")),
                      DataColumn(label: Text("ราคา")),
                      DataColumn(label: Text("รวม")),
                      DataColumn(label: Text("โต๊ะ")),
                      DataColumn(label: Text("สถานะ")),
                    ],
                    rows:
                        orders.map((order) {
                          return DataRow(
                            cells: [
                              DataCell(Text(order.detailNo.toString())),
                              DataCell(
                                Row(
                                  children: [
                                    Image.network(
                                      order.menuImage,
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover,
                                    ),
                                    const SizedBox(width: 8),
                                    SizedBox(
                                      width: 100, // กำหนดความกว้างเมนู
                                      child: Text(
                                        order.menuName,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              DataCell(Text(order.menuType)),
                              DataCell(Text(order.amount.toString())),
                              DataCell(Text(order.price.toStringAsFixed(2))),
                              DataCell(
                                Text(order.totalCost.toStringAsFixed(2)),
                              ),
                              DataCell(Text(order.tableNo.toString())),
                              DataCell(
                                DropdownButton<String>(
                                  value:
                                      selectedTracks[order.detailNo] ??
                                      order.trackStateName,
                                  items:
                                      tracks
                                          .map(
                                            (t) => DropdownMenuItem(
                                              value: t.trackStateName,
                                              child: Text(t.trackStateName),
                                            ),
                                          )
                                          .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedTracks[order.detailNo] = value!;
                                      final newTrack = tracks.firstWhere(
                                        (t) => t.trackStateName == value,
                                      );
                                      _updateTrack(order, newTrack);
                                    });
                                  },
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
