import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:laundriin_customer/core/routes/app_router.gr.dart';
import 'package:qr_flutter/qr_flutter.dart';

@RoutePage()
class DropTicketPage extends StatelessWidget {
  final String transactionId;
  final String
  qrCode; // Base64 or raw string depending on usage, but we'll use transactionId for QrImageView

  const DropTicketPage({
    super.key,
    required this.transactionId,
    required this.qrCode,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        context.router.replaceAll([const MainRoute()]);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => context.router.replaceAll([const MainRoute()]),
          ),
        title: const Text(
          'Drop Ticket',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => context.router.push(
              PaymentDetailRoute(
                orderId: transactionId,
                paymentId:
                    '', // Assuming empty string as it is required but unavailable here
              ),
            ),
            child: const Text(
              'Done',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 20,
                      spreadRadius: 5,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: _QrScannerCard(
                  transactionId: transactionId,
                  qrCodeImage: qrCode,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                transactionId,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B233A),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'ACTIVE',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.blue.shade100),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.blue.shade700,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Panduan Drop & Go',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color(0xFF1B233A),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildGuideStep(
                      '1',
                      'Tunjukkan QR ini ke kasir untuk di scan.',
                    ),
                    const SizedBox(height: 8),
                    _buildGuideStep('2', 'Tunggu kasir menimbang cucian Anda.'),
                    const SizedBox(height: 8),
                    _buildGuideStep(
                      '3',
                      'Anda akan diarahkan ke halaman Detail Pesanan.',
                    ),
                    const SizedBox(height: 8),
                    _buildGuideStep(
                      '4',
                      'Selesaikan pembayaran pesanan Anda langsung dari aplikasi.',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => context.router.replaceAll([const MainRoute()]),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.blueGrey,
                    side: BorderSide(color: Colors.grey.shade300),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  icon: const Icon(Icons.cancel, size: 20),
                  label: const Text(
                    'Batalkan Pesanan',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.brightness_high,
                    size: 16,
                    color: Colors.blueGrey.shade300,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Screen brightness set to max for scanning',
                    style: TextStyle(
                      color: Colors.blueGrey.shade300,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    ));
  }

  Widget _buildGuideStep(String number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: Colors.blue.shade200,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            number,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade900,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.blueGrey,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

class _QrScannerCard extends StatelessWidget {
  final String transactionId;
  final String qrCodeImage;

  const _QrScannerCard({
    required this.transactionId,
    required this.qrCodeImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      height: 260,
      decoration: BoxDecoration(
        color: const Color(0xFF2E3A4A),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Blue scan corners
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildCorner(isTop: true, isLeft: true),
                      _buildCorner(isTop: true, isLeft: false),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildCorner(isTop: false, isLeft: true),
                      _buildCorner(isTop: false, isLeft: false),
                    ],
                  ),
                ],
              ),
            ),
          ),
          QrImageView(
            data: transactionId,
            version: QrVersions.auto,
            size: 210.0,
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildCorner({required bool isTop, required bool isLeft}) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        border: Border(
          top: isTop
              ? const BorderSide(color: Colors.blue, width: 4)
              : BorderSide.none,
          bottom: !isTop
              ? const BorderSide(color: Colors.blue, width: 4)
              : BorderSide.none,
          left: isLeft
              ? const BorderSide(color: Colors.blue, width: 4)
              : BorderSide.none,
          right: !isLeft
              ? const BorderSide(color: Colors.blue, width: 4)
              : BorderSide.none,
        ),
        borderRadius: BorderRadius.only(
          topLeft: isTop && isLeft ? const Radius.circular(12) : Radius.zero,
          topRight: isTop && !isLeft ? const Radius.circular(12) : Radius.zero,
          bottomLeft: !isTop && isLeft
              ? const Radius.circular(12)
              : Radius.zero,
          bottomRight: !isTop && !isLeft
              ? const Radius.circular(12)
              : Radius.zero,
        ),
      ),
    );
  }
}
