import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundriin_customer/features/order/presentation/cubit/order_cubit.dart';
import 'package:laundriin_customer/features/order/presentation/cubit/order_state.dart';
import 'package:laundriin_customer/features/outlet/presentation/cubit/outlet_cubit.dart';
import 'package:laundriin_customer/features/outlet/presentation/cubit/outlet_state.dart';

import '../../../../core/routes/app_router.gr.dart';

@RoutePage()
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderCubit>().fetchActiveOrders();
      context.read<OutletCubit>().fetchNearbyOutlets(
        latitude: -6.9824,
        longitude: 107.6301,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await context.read<OrderCubit>().fetchActiveOrders();
            if (context.mounted) {
              await context.read<OutletCubit>().fetchNearbyOutlets(
                latitude: -6.9824,
                longitude: 107.6301,
              );
            }
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // const _HeaderSection(),
                const SizedBox(height: 24),
                const _WelcomeSection(),
                const SizedBox(height: 24),
                const _DropAndGoCard(),
                const SizedBox(height: 24),
                const _ActiveOrderSection(),
                const SizedBox(height: 24),
                const _QuickActionsSection(),
                const SizedBox(height: 24),
                const _NearbyOutletsSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class _HeaderSection extends StatelessWidget {
//   const _HeaderSection();

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Current Location',
//               style: TextStyle(
//                 color: Colors.black54,
//                 fontSize: 12,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Row(
//               children: [
//                 const Icon(Icons.location_pin, color: Colors.red, size: 16),
//                 const SizedBox(width: 4),
//                 const Text(
//                   'Laundry Express - Tebe...',
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//                 ),
//                 const SizedBox(width: 2),
//                 Icon(
//                   Icons.keyboard_arrow_down,
//                   size: 18,
//                   color: Colors.blue.shade700,
//                 ),
//               ],
//             ),
//           ],
//         ),
//         Container(
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: Colors.grey.shade50,
//             shape: BoxShape.circle,
//             border: Border.all(color: Colors.grey.shade200),
//           ),
//           child: Stack(
//             clipBehavior: Clip.none,
//             children: [
//               const Icon(Icons.notifications_none, size: 24),
//               Positioned(
//                 right: 2,
//                 top: 2,
//                 child: Container(
//                   width: 8,
//                   height: 8,
//                   decoration: const BoxDecoration(
//                     color: Colors.red,
//                     shape: BoxShape.circle,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

class _WelcomeSection extends StatelessWidget {
  const _WelcomeSection();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Welcome back, Andi 👋',
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }
}

class _DropAndGoCard extends StatelessWidget {
  const _DropAndGoCard();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.router.push(const SelectOutletRoute());
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1E88E5), // Blue shade
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Mulai Drop & Go',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Scan QR to drop laundry',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.qr_code_scanner,
                color: Colors.white,
                size: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActiveOrderSection extends StatelessWidget {
  const _ActiveOrderSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderCubit, OrderState>(
      builder: (context, state) {
        if (state is OrderActiveLoaded) {
          final activeOrders = state.activeOrders;
          if (activeOrders.isEmpty) {
            return const SizedBox(); // Atau tampilkan placeholder "Belum ada order"
          }

          final order = activeOrders.first;

          // Map status to progress steps
          // 1: menunggu_drop, 2: menunggu_ditimbang, 3: sedang_diproses, 4: siap_diambil, 5: selesai
          int currentStep = 1;
          String statusText = 'Unknown';
          if (order.orderStatus == 'menunggu_drop') {
            currentStep = 1;
            statusText = 'Menunggu Drop';
          } else if (order.orderStatus == 'menunggu_ditimbang') {
            currentStep = 2;
            statusText = 'Menunggu Ditimbang';
          } else if (order.orderStatus == 'sedang_diproses') {
            currentStep = 3;
            statusText = 'Sedang Diproses';
          } else if (order.orderStatus == 'siap_diambil') {
            currentStep = 4;
            statusText = 'Siap Diambil';
          } else if (order.orderStatus == 'selesai') {
            currentStep = 5;
            statusText = 'Selesai';
          }

          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Active Order',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          state.activeOrders.length.toString(),
                          style: TextStyle(color: Colors.orange.shade700),
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      context.router.push(const ActiveOrderRoute());
                    },
                    child: Text(
                      'View All',
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  if (order.orderStatus == 'menunggu_drop') {
                    context.router.push(
                      DropTicketRoute(
                        transactionId: order.transactionId ?? '',
                        qrCode: order.dropQrCode ?? '',
                      ),
                    );
                  } else {
                    context.router.push(OrderTrackingRoute(orderId: order.id ?? ''));
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Order Header
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.hourglass_bottom,
                              color: Colors.blue.shade700,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      order.serviceName ?? '',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    order.totalPrice != null
                                        ? Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade50,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              order.totalPrice.toString(),
                                              style: TextStyle(
                                                color: Colors.grey.shade800,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  order.outletName ?? '',
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Progress Info
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            statusText,
                            style: TextStyle(
                              color: Colors.blue.shade700,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Step $currentStep/5',
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Progress Bar
                      Stack(
                        children: [
                          Container(
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              return Container(
                                height: 6,
                                width: constraints.maxWidth * (currentStep / 5),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade500,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Steps Icons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _OrderStep(
                            icon: Icons.inventory_2_outlined,
                            label: 'Drop',
                            state: currentStep > 1
                                ? _StepState.done
                                : (currentStep == 1
                                      ? _StepState.active
                                      : _StepState.todo),
                          ),
                          Expanded(child: _StepLine(isDone: currentStep > 1)),
                          _OrderStep(
                            icon: Icons.scale_outlined,
                            label: 'Weight',
                            state: currentStep > 2
                                ? _StepState.done
                                : (currentStep == 2
                                      ? _StepState.active
                                      : _StepState.todo),
                          ),
                          Expanded(child: _StepLine(isDone: currentStep > 2)),
                          _OrderStep(
                            icon: Icons.local_laundry_service_outlined,
                            label: 'Wash',
                            state: currentStep > 3
                                ? _StepState.done
                                : (currentStep == 3
                                      ? _StepState.active
                                      : _StepState.todo),
                          ),
                          Expanded(child: _StepLine(isDone: currentStep > 3)),
                          _OrderStep(
                            icon: Icons.storefront_outlined,
                            label: 'Pickup',
                            state: currentStep > 4
                                ? _StepState.done
                                : (currentStep == 4
                                      ? _StepState.active
                                      : _StepState.todo),
                          ),
                          Expanded(child: _StepLine(isDone: currentStep > 4)),
                          _OrderStep(
                            icon: Icons.check_circle_outline,
                            label: 'Done',
                            state: currentStep == 5
                                ? _StepState.done
                                : _StepState.todo,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        } else if (state is OrderLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return const SizedBox();
      },
    );
  }
}

class _StepLine extends StatelessWidget {
  final bool isDone;

  const _StepLine({required this.isDone});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: 8).copyWith(bottom: 20),
      color: isDone ? Colors.blue.shade200 : Colors.grey.shade300,
    );
  }
}

class _OrderStep extends StatelessWidget {
  final IconData icon;
  final String label;
  final _StepState state;

  const _OrderStep({
    required this.icon,
    required this.label,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (state) {
      case _StepState.done:
        color = Colors.blue.shade500;
        break;
      case _StepState.active:
        color = Colors.black87;
        break;
      case _StepState.todo:
        color = Colors.grey.shade400;
        break;
    }

    return Column(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: state == _StepState.active
                ? FontWeight.bold
                : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

class _QuickActionsSection extends StatelessWidget {
  const _QuickActionsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _ActionCard(
                icon: Icons.account_balance_wallet_outlined,
                color: Colors.green.shade600,
                label: 'Top Up Wallet',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _ActionCard(
                icon: Icons.sell_outlined,
                color: Colors.purple.shade400,
                label: 'Price List',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;

  const _ActionCard({
    required this.icon,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class _NearbyOutletsSection extends StatelessWidget {
  const _NearbyOutletsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nearby Outlets',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        BlocBuilder<OutletCubit, OutletState>(
          builder: (context, state) {
            if (state is OutletLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is OutletError) {
              return Text(
                'Gagal memuat outlet: ${state.message}',
                style: const TextStyle(color: Colors.red),
              );
            } else if (state is OutletListLoaded) {
              final outlets = state.outlets;
              if (outlets.isEmpty) {
                return const Text('Tidak ada outlet terdekat.');
              }

              return Column(
                children: outlets.map((outlet) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _OutletCard(
                      name: outlet.name ?? '',
                      address: outlet.address ?? '',
                      status: outlet.isOpen == true ? 'Open' : 'Closed',
                      distance: '${outlet.distanceKm ?? 0} km',
                      statusColor: outlet.isOpen == true
                          ? Colors.green
                          : Colors.grey.shade600,
                    ),
                  );
                }).toList(),
              );
            }
            return const SizedBox();
          },
        ),
      ],
    );
  }
}

class _OutletCard extends StatelessWidget {
  final String name;
  final String address;
  final String status;
  final String distance;
  final Color statusColor;

  const _OutletCard({
    required this.name,
    required this.address,
    required this.status,
    required this.distance,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 65,
              height: 65,
              color: Colors.grey.shade200,
              child: const Icon(Icons.store, color: Colors.grey, size: 30),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  address,
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(radius: 3, backgroundColor: statusColor),
                          const SizedBox(width: 4),
                          Text(
                            status,
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '• $distance',
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.directions_outlined,
              color: Colors.blue.shade600,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

enum _StepState { done, active, todo }
