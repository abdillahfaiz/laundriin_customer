import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

/// Halaman daftar order — placeholder.
@RoutePage()
class OrderListPage extends StatelessWidget {
  const OrderListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pesanan Saya')),
      body: const Center(child: Text('Order List Page - TODO: Implement UI')),
    );
  }
}
