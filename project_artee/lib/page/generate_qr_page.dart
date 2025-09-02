import 'dart:io';
import 'package:flutter/material.dart';
import 'package:project_artee/services/genarate_qr_api.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class GenerateQrPage extends StatefulWidget {
  const GenerateQrPage({super.key});

  @override
  State<GenerateQrPage> createState() => _GenerateQrPageState();
}

class _GenerateQrPageState extends State<GenerateQrPage> {
  final TextEditingController _tableCtrl = TextEditingController();
  final ScreenshotController _screenshotController = ScreenshotController();

  String _qrData = "";
  bool _loading = false;

  Future<void> _createOrder() async {
    if (_tableCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("กรุณากรอกหมายเลขโต๊ะ")));
      return;
    }

    setState(() => _loading = true);

    final tableNo = int.tryParse(_tableCtrl.text.trim()) ?? 0;
    final result = await OrderService.generateOrder(tableNo);

    setState(() => _loading = false);

    if (result["success"]) {
      setState(() {
        _qrData = result["data"]["authUrl"];
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result["message"])));
    }
  }

  Future<void> _saveQR() async {
    if (_qrData.isEmpty) return;
    final directory = await getApplicationDocumentsDirectory();
    final filePath = "${directory.path}/qrcode.png";

    final image = await _screenshotController.capture();
    if (image == null) return;

    final file = File(filePath);
    await file.writeAsBytes(image);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("บันทึกแล้ว: $filePath")));
  }

  Future<void> _shareQR() async {
    if (_qrData.isEmpty) return;

    final directory = await getTemporaryDirectory();
    final filePath = "${directory.path}/qrcode.png";

    final image = await _screenshotController.capture();
    if (image == null) return;

    final file = File(filePath);
    await file.writeAsBytes(image);

    await Share.shareXFiles([XFile(filePath)], text: "นี่คือ QR Code 🎉");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Generate Order QR")),
      body: SingleChildScrollView(
        // ✅ เพิ่ม SingleChildScrollView
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _tableCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "กรอกหมายเลขโต๊ะ",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            ElevatedButton.icon(
              onPressed: _loading ? null : _createOrder,
              icon:
                  _loading
                      ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                      : const Icon(Icons.qr_code),
              label: const Text("สร้าง QR"),
            ),

            const SizedBox(height: 20),

            if (_qrData.isNotEmpty)
              Screenshot(
                controller: _screenshotController,
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(12),
                  child: QrImageView(
                    data: _qrData,
                    size: 220,
                    version: QrVersions.auto,
                  ),
                ),
              ),

            const SizedBox(height: 20),

            if (_qrData.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: _saveQR,
                    icon: const Icon(Icons.save),
                    label: const Text("บันทึก"),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: _shareQR,
                    icon: const Icon(Icons.share),
                    label: const Text("แชร์"),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
