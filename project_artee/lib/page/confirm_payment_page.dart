import 'package:flutter/material.dart';
import 'package:project_artee/services/confirm_payment_api.dart';
import 'package:photo_view/photo_view.dart';
import 'package:project_artee/widgets/Calculate_widget.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late Future<List<Payment>> futurePayments;

  @override
  void initState() {
    super.initState();
    futurePayments = PaymentService.fetchPayments();
  }

  void refreshPayments() {
    setState(() {
      futurePayments = PaymentService.fetchPayments();
    });
  }

  void showImageDialog(String imageUrl) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            child: SizedBox(
              width: double.infinity,
              height: 400,
              child: PhotoView(
                imageProvider: NetworkImage(imageUrl),
                backgroundDecoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        title: const Text("ตรวจสอบการชำระเงิน"),
        backgroundColor: Colors.deepOrange,
      ),
      body: FutureBuilder<List<Payment>>(
        future: futurePayments,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("ไม่มีรายการชำระเงินรอการตรวจสอบ"));
          }

          final payments = snapshot.data!;

          return ListView(
            children:
                payments.map((p) {
                  if (p.methodName == "CASH") {
                    // ✅ แสดง CalculateWidget สำหรับ CASH
                    return CalculateWidget(
                      payment: p,
                      onSuccess: refreshPayments, // ✅ เรียก refresh เมื่อสำเร็จ
                      onTapImage:
                          p.image != null
                              ? () => showImageDialog(p.image!)
                              : null,
                    );
                  } else if (p.methodName == "PROMPTPAY") {
                    // ✅ แสดง Card พร้อมปุ่ม Confirm สำหรับ PromptPay
                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        leading:
                            p.image != null
                                ? GestureDetector(
                                  onTap: () => showImageDialog(p.image!),
                                  child: Image.network(
                                    p.image!,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                )
                                : const Icon(
                                  Icons.receipt,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                        title: Text("Payment #${p.paymentNo} - ${p.status}"),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Order No: ${p.orderNo} | Table: ${p.tableNo}",
                            ),
                            Text("Method: ${p.methodName}"),
                            Text("Total: ${p.totalCost} ฿"),
                          ],
                        ),
                        isThreeLine: true,
                        trailing: ElevatedButton(
                          onPressed: () {
                            PaymentService.confirmPayment(p.paymentNo).then((
                              success,
                            ) {
                              if (success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "ยืนยัน PromptPay เรียบร้อยแล้ว ✅",
                                    ),
                                  ),
                                );
                                refreshPayments(); // ✅ refresh หลังจาก confirm สำเร็จ
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("ยืนยัน PromptPay ล้มเหลว ❌"),
                                  ),
                                );
                              }
                            });
                          },
                          child: const Text("Confirm"),
                        ),
                      ),
                    );
                  } else {
                    // ✅ สำหรับวิธีอื่น ๆ (เช่น QR, Credit card)
                    return const SizedBox.shrink();
                  }
                }).toList(),
          );
        },
      ),
    );
  }
}
