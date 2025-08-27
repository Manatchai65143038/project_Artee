import 'dart:io';
import 'package:flutter/material.dart';
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
  final TextEditingController _textCtrl = TextEditingController();
  final ScreenshotController _screenshotController = ScreenshotController();

  String _qrData = "";

  void _generateQR() {
    if (_textCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("กรุณากรอกข้อความก่อน")));
      return;
    }
    setState(() {
      _qrData = _textCtrl.text.trim();
    });
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

    await Share.shareXFiles([
      XFile(filePath),
    ], text: "นี่คือ QR Code ของฉัน 🎉");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // ✅ ป้องกัน overflow
      appBar: AppBar(title: const Text("Generate & Share QR Code")),
      body: SingleChildScrollView(
        // ✅ หุ้มด้วย scroll
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ช่องกรอกข้อความ
            TextField(
              controller: _textCtrl,
              decoration: const InputDecoration(
                labelText: "ข้อความหรือ URL",
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _generateQR(),
            ),
            const SizedBox(height: 12),

            ElevatedButton.icon(
              onPressed: _generateQR,
              icon: const Icon(Icons.qr_code),
              label: const Text("สร้าง QR"),
            ),

            const SizedBox(height: 20),

            // แสดง QR (ถ้ามีข้อมูล)
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

            // ปุ่ม Save / Share
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
