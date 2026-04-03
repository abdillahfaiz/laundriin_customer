import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

/// Halaman daftar outlet — placeholder.
@RoutePage()
class OutletListPage extends StatelessWidget {
  const OutletListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Outlet Terdekat')),
      body: const Center(child: Text('Outlet List Page - TODO: Implement UI')),
    );
  }
}
