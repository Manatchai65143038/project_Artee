import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:project_artee/services/confirm_payment_api.dart';

class CalculateWidget extends StatefulWidget {
  final Payment payment;
  final VoidCallback? onTapImage;
  final VoidCallback? onSuccess; // ✅ callback ไปที่ PaymentPage

  const CalculateWidget({
    super.key,
    required this.payment,
    this.onTapImage,
    this.onSuccess,
  });

  @override
  State<CalculateWidget> createState() => _CalculateWidgetState();
}

class _CalculateWidgetState extends State<CalculateWidget> {
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

  void showPaymentDialog(Payment payment) {
    final TextEditingController paymentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("ชำระเงิน - Payment #${payment.paymentNo}"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("ยอดที่ต้องจ่าย: ${payment.totalCost} ฿"),
              const SizedBox(height: 10),
              TextField(
                controller: paymentController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "รับเงินจากลูกค้า",
                  prefixText: "฿ ",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("ยกเลิก"),
            ),
            ElevatedButton(
              onPressed: () {
                final enteredAmount = int.tryParse(paymentController.text);
                if (enteredAmount == null ||
                    enteredAmount < payment.totalCost) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("เงินไม่เพียงพอ")),
                  );
                  return;
                }

                final change = enteredAmount - payment.totalCost;
                Navigator.pop(context); // ปิด dialog กรอกเงิน
                showReceiptDialog(payment, enteredAmount, change);
              },
              child: const Text("ชำระเงิน"),
            ),
          ],
        );
      },
    );
  }

  void showReceiptDialog(Payment payment, int received, int change) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("ใบเสร็จ"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Payment No: ${payment.paymentNo}"),
              Text("Order No: ${payment.orderNo} | Table: ${payment.tableNo}"),
              Text("วิธีชำระ: ${payment.methodName}"),
              Text("ยอดรวม: ${payment.totalCost} ฿"),
              Text("รับเงิน: $received ฿"),
              Text("เงินทอน: $change ฿"),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                try {
                  final success = await PaymentService.confirmPayment(
                    payment.paymentNo,
                  );
                  if (success) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("ยืนยันการชำระเงินสำเร็จ ✅"),
                        ),
                      );
                    }
                    Navigator.pop(context); // ปิดใบเสร็จ
                    widget.onSuccess?.call(); // แจ้ง PaymentPage ให้ refresh
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text("Error: $e")));
                  }
                }
              },
              child: const Text("ปิด"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.payment;
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
                : const Icon(Icons.receipt, size: 50, color: Colors.grey),
        title: Text("Payment #${p.paymentNo} - ${p.status}"),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Order No: ${p.orderNo} | Table: ${p.tableNo}"),
            Text("Method: ${p.methodName}"),
            Text("Total: ${p.totalCost} ฿"),
          ],
        ),
        isThreeLine: true,
        trailing:
            p.status == "PENDING"
                ? ElevatedButton(
                  onPressed: () => showPaymentDialog(p),
                  child: const Text("รับเงิน"),
                )
                : null,
      ),
    );
  }
}
