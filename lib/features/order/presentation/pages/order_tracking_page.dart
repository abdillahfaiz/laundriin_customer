import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/routes/app_router.gr.dart';
import '../cubit/order_cubit.dart';
import '../cubit/order_state.dart';

@RoutePage()
class OrderTrackingPage extends StatelessWidget {
  final String orderId;

  const OrderTrackingPage({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<OrderCubit>()..fetchOrderDetail(orderId),
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => context.router.maybePop(),
          ),
          title: BlocBuilder<OrderCubit, OrderState>(
            builder: (context, state) {
              if (state is OrderDetailLoaded) {
                return Text(
                  'Order #${state.order.transactionId ?? state.order.id?.substring(0, 8)}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }
              return const Text(
                'Order Details',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.black),
              onPressed: () {
                context.read<OrderCubit>().fetchOrderDetail(orderId);
              },
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await context.read<OrderCubit>().fetchOrderDetail(orderId);
          },
          child: BlocBuilder<OrderCubit, OrderState>(
            builder: (context, state) {
              if (state is OrderLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is OrderError) {
                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: Center(child: Text(state.message)),
                    ),
                  ],
                );
              } else if (state is OrderDetailLoaded) {
                final order = state.order;
                final logs = order.statusLogs ?? [];

                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (order.payment?.status == 'pending')
                          Container(
                            margin: const EdgeInsets.only(bottom: 24),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.yellow.shade50,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.yellow.shade200),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.warning_amber_rounded,
                                      color: Colors.yellow.shade800,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Selesaikan Pembayaran',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.yellow.shade900,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Segera selesaikan pembayaran untuk dapat mengambil cucian Anda.',
                                  style: TextStyle(
                                    color: Colors.yellow.shade900,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: double.infinity,
                                  child: TextButton(
                                    onPressed: () {
                                      context.router.push(
                                        PaymentDetailRoute(
                                          orderId: order.id ?? '',
                                          paymentId: order.payment?.id ?? '',
                                        ),
                                      );
                                    },
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.yellow.shade100,
                                      foregroundColor: Colors.yellow.shade900,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text(
                                      'Lanjutkan Pembayaran',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        else if ((order.paymentStatus == null ||
                                order.paymentStatus!.toLowerCase() ==
                                    'pending') &&
                            order.totalPrice != null)
                          Container(
                            margin: const EdgeInsets.only(bottom: 24),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.orange.shade200),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.warning_amber_rounded,
                                      color: Colors.orange.shade800,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Tagihan Belum Lunas',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orange.shade900,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Segera selesaikan pembayaran untuk dapat mengambil cucian Anda.',
                                  style: TextStyle(
                                    color: Colors.orange.shade900,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: double.infinity,
                                  child: TextButton(
                                    onPressed: () {
                                      context.router.push(
                                        PaymentRoute(order: order),
                                      );
                                    },
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.orange.shade100,
                                      foregroundColor: Colors.orange.shade900,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text(
                                      'Pilih Metode Pembayaran',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        // Header Card
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey.shade200),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.02),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Icon(
                                  Icons.local_laundry_service,
                                  size: 40,
                                  color: Colors.blue,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          order.serviceName ??
                                              'Laundry Service',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Color(0xFF1B233A),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${order.actualWeight != null ? '${order.actualWeight}kg' : ('${order.estimatedBags} bags')} • ${order.outletName ?? ''}',
                                      style: TextStyle(
                                        color: Colors.blueGrey.shade400,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.access_time,
                                          size: 14,
                                          color: Colors.blueGrey.shade400,
                                        ),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            order.durasiName != null
                                                ? 'Durasi: ${order.durasiName}'
                                                : 'Sedang dihitung',
                                            style: TextStyle(
                                              color: Colors.blueGrey.shade600,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Status Timeline
                        const Text(
                          'Order Status',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1B233A),
                          ),
                        ),
                        const SizedBox(height: 24),
                        if (logs.isEmpty)
                          const Text('Belum ada log status.')
                        else
                          ...logs.asMap().entries.map((entry) {
                            final idx = entry.key;
                            final log = entry.value;
                            final isLast = idx == logs.length - 1;
                            final isCurrent =
                                isLast && order.orderStatus != 'selesai';
                            final isCompleted = !isCurrent;

                            IconData icon = Icons.info_outline;
                            Color colorWrapper = Colors.blue;
                            String titleStatus = '';

                            if (log.status == 'menunggu_drop') {
                              titleStatus = 'Menunggu Drop';
                              icon = Icons.inventory_2_outlined;
                              colorWrapper = Colors.orange;
                            } else if (log.status == 'menunggu_ditimbang') {
                              titleStatus = 'Menunggu Ditimbang';
                              icon = Icons.payment;
                              colorWrapper = Colors.amber;
                            } else if (log.status == 'sedang_diproses') {
                              titleStatus = 'Sedang Diproses';
                              icon = Icons.local_laundry_service;
                              colorWrapper = Colors.blue;
                            } else if (log.status == 'siap_diambil') {
                              titleStatus = 'Siap Diambil';
                              icon = Icons.check_circle_outline;
                              colorWrapper = Colors.green;
                            } else if (log.status == 'selesai') {
                              titleStatus = 'Selesai';
                              icon = Icons.done_all;
                              colorWrapper = Colors.teal;
                            }

                            return _buildTimelineItem(
                              title: titleStatus,
                              description: log.note ?? '',
                              time: DateFormat(
                                'MMM dd, hh:mm a',
                              ).format(log.createdAt ?? DateTime.now()),
                              isCompleted: isCompleted,
                              isCurrent: isCurrent,
                              iconWrapperColor: colorWrapper,
                              icon: icon,
                              isLast: isLast,
                            );
                          }),

                        const SizedBox(height: 32),

                        // Order Details Card
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'ORDER DETAILS',
                                style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(height: 20),
                              if (order.transactionId != null) ...[
                                _buildDetailRow(
                                  'Transaction ID',
                                  order.transactionId!,
                                  isBold: true,
                                ),
                                const SizedBox(height: 16),
                              ],
                              _buildDetailRow(
                                'Date',
                                DateFormat(
                                  'MMM dd, yyyy',
                                ).format(order.createdAt ?? DateTime.now()),
                                isBold: true,
                              ),
                              if (order.paymentStatus != null) ...[
                                const SizedBox(height: 16),
                                _buildDetailRow(
                                  'Payment',
                                  order.paymentStatus == 'settlement'
                                      ? 'LUNAS'
                                      : order.paymentStatus!.toUpperCase(),
                                  isBold: true,
                                ),
                              ],
                              if (order.parfumName != null) ...[
                                const SizedBox(height: 16),
                                _buildDetailRow(
                                  'Parfum',
                                  order.parfumName!,
                                  isBold: true,
                                ),
                              ],
                              const SizedBox(height: 16),
                              const Divider(height: 1),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Total',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Color(0xFF1B233A),
                                    ),
                                  ),
                                  Text(
                                    order.totalPrice != null
                                        ? 'Rp ${order.totalPrice!.toStringAsFixed(0)}'
                                        : 'TBD',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.blue.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ),
        bottomNavigationBar: BlocBuilder<OrderCubit, OrderState>(
          builder: (context, state) {
            if (state is OrderDetailLoaded &&
                state.order.orderStatus == 'siap_diambil') {
              return Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(color: Colors.grey.shade50),
                child: SafeArea(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          enableDrag: true,
                          scrollControlDisabledMaxHeightRatio: 0.7,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          builder: (context) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                right: 24,
                                left: 24,
                                top: 24,
                                bottom: 40,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // const Text(
                                  //   'QR Pengambilan',
                                  //   style: TextStyle(
                                  //     fontSize: 18,
                                  //     fontWeight: FontWeight.bold,
                                  //     color: Color(0xFF1B233A),
                                  //   ),
                                  // ),
                                  const Text(
                                    'Tunjukkan QR Code ini kepada petugas outlet untuk mengambil laundry Anda.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: Colors.grey.shade200,
                                      ),
                                    ),
                                    child: QrImageView(
                                      data: state.order.id ?? '',
                                      version: QrVersions.auto,
                                      size: 200.0,
                                    ),
                                  ),
                                  const SizedBox(height: 40),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.qr_code_2),
                      label: const Text(
                        'Lihat QR Pengambilan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildTimelineItem({
    required String title,
    required String description,
    required String time,
    required bool isCompleted,
    required bool isCurrent,
    required Color iconWrapperColor,
    Color? iconColor,
    required IconData icon,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isCompleted || isCurrent
                    ? iconWrapperColor
                    : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isCurrent
                      ? Colors.blue.shade100
                      : (isCompleted ? iconWrapperColor : Colors.grey.shade300),
                  width: isCurrent ? 4 : 2,
                ),
              ),
              child: Icon(
                icon,
                color: isCompleted || isCurrent
                    ? Colors.white
                    : (iconColor ?? Colors.grey.shade400),
                size: 20,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 50,
                color: isCompleted ? iconWrapperColor : Colors.grey.shade200,
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isCurrent
                      ? Colors.blue.shade600
                      : (isCompleted
                            ? const Color(0xFF1B233A)
                            : Colors.blueGrey),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(color: Colors.blueGrey.shade400, fontSize: 13),
              ),
              const SizedBox(height: 4),
              if (time.isNotEmpty)
                Text(
                  time,
                  style: TextStyle(
                    color: isCurrent
                        ? Colors.blue.shade600
                        : Colors.blueGrey.shade400,
                    fontSize: 12,
                    fontWeight: isCurrent ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.blueGrey.shade400, fontSize: 14),
        ),
        Text(
          value,
          style: TextStyle(
            color: const Color(0xFF1B233A),
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
