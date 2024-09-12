// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class Scanner extends StatefulWidget {
  const Scanner({super.key});

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  final GlobalKey qrKey = GlobalKey();
  Barcode? barcode;
  String result = "";
  QRViewController? _controller;

  @override
  Widget build(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 350.0;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          QRView(
              key: qrKey,
              overlay: QrScannerOverlayShape(
                  borderColor: Colors.red,
                  borderLength: 30,
                  borderRadius: 10,
                  borderWidth: 10,
                  cutOutSize: scanArea),
              onQRViewCreated: (QRViewController controller) {
                _controller = controller;
                controller.scannedDataStream.listen((value) {
                  if (mounted) {
                    _controller!.dispose();
                    Navigator.pop(context, value.code);
                    print(value.code);
                  }
                });
              })
        ],
      ),
    );
  }
}
