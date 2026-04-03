import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laundriin_customer/core/di/injection_container.dart';
import 'package:laundriin_customer/core/routes/app_router.gr.dart';
import 'package:laundriin_customer/features/outlet/domain/usecases/get_outlet_items.dart';

import '../../../outlet/domain/entities/outlet_durasi.dart';
import '../../../outlet/domain/entities/outlet_item.dart';
import '../../../outlet/domain/entities/outlet_layanan.dart';
import '../../../outlet/domain/entities/outlet_parfum.dart';
import '../../../outlet/domain/usecases/get_outlet_durasi.dart';
import '../../../outlet/domain/usecases/get_outlet_layanan.dart';
import '../../../outlet/domain/usecases/get_outlet_parfum.dart';
import '../../../outlet/domain/usecases/get_durasi_per_item.dart';
import '../../../outlet/domain/usecases/get_jenis_by_item.dart';
import '../../domain/usecases/create_order.dart';
import '../cubit/order_cubit.dart';
import '../cubit/order_state.dart';

@RoutePage()
class OrderSetupPage extends StatefulWidget {
  final String outletId;

  const OrderSetupPage({super.key, required this.outletId});

  @override
  State<OrderSetupPage> createState() => _OrderSetupPageState();
}

enum ServiceType { kiloan, satuan }

class _OrderSetupPageState extends State<OrderSetupPage> {
  late final ValueNotifier<ServiceType> selectedServiceNotifier;
  late final ValueNotifier<Map<String, int>> selectedItemsNotifier;
  late final TextEditingController notesController;

  late final ValueNotifier<OutletLayanan?> kiloanLayananNotifier;
  late final ValueNotifier<OutletDurasi?> kiloanDurasiNotifier;
  late final ValueNotifier<OutletParfum?> kiloanParfumNotifier;

  late final ValueNotifier<OutletLayanan?> satuanLayananNotifier;
  late final ValueNotifier<OutletDurasi?> satuanDurasiNotifier;
  late final ValueNotifier<OutletParfum?> satuanParfumNotifier;

  List<OutletLayanan> _kiloanServices = [];
  List<OutletDurasi> _kiloanDurations = [];
  List<OutletParfum> _kiloanParfums = [];

  List<OutletLayanan> _satuanServices = [];
  List<OutletDurasi> _satuanDurations = [];
  List<OutletItem> _satuanItemsList = [];
  bool isLoadingSatuanItems = false;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    selectedServiceNotifier = ValueNotifier(ServiceType.kiloan);
    selectedItemsNotifier = ValueNotifier({});
    notesController = TextEditingController();

    kiloanLayananNotifier = ValueNotifier(null);
    kiloanDurasiNotifier = ValueNotifier(null);
    kiloanParfumNotifier = ValueNotifier(null);

    satuanLayananNotifier = ValueNotifier(null);
    satuanDurasiNotifier = ValueNotifier(null);
    satuanParfumNotifier = ValueNotifier(null);

    _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    final getLayanan = sl<GetOutletLayananPerKg>();
    final getParfum = sl<GetOutletParfum>();

    final layananResult = await getLayanan(widget.outletId);
    if (mounted) {
      layananResult.fold(
        (failure) => debugPrint('Error layanan: ${failure.message}'),
        (layanan) {
          final Set<String> seenKiloan = {};
          _kiloanServices = layanan.where((e) {
             final isKiloan = e.tipe == null || e.tipe?.toLowerCase() == 'per_kg' || e.tipe?.toLowerCase() == 'per-kg';
             if (isKiloan && e.id != null) {
               if (seenKiloan.contains(e.id)) return false;
               seenKiloan.add(e.id!);
               return true;
             }
             return false;
          }).toList();

          final Set<String> seenSatuan = {};
          _satuanServices = layanan.where((e) {
             final isSatuan = e.tipe?.toLowerCase() == 'per_item' || e.tipe?.toLowerCase() == 'per-item';
             if (isSatuan && e.id != null) {
               if (seenSatuan.contains(e.id)) return false;
               seenSatuan.add(e.id!);
               return true;
             }
             return false;
          }).toList();
        },
      );
    }
    
    // Always call to fetch items, and it will fetch fallback categories if _satuanServices is empty
    _fetchSatuanItems('');

    final parfumResult = await getParfum(widget.outletId);
    if (mounted) {
      parfumResult.fold(
        (failure) => debugPrint('Error parfum: ${failure.message}'),
        (parfum) {
          _kiloanParfums = parfum;
        },
      );
      setState(() {
        isLoading = false;
        if (_kiloanParfums.isNotEmpty) {
          kiloanParfumNotifier.value = _kiloanParfums.first;
          satuanParfumNotifier.value = _kiloanParfums.first;
        }
      });
    }
  }

  Future<void> _fetchDurasi(String layananId, ServiceType type) async {
    if (type == ServiceType.kiloan) {
      final getDurasi = sl<GetOutletDurasiPerKg>();
      final result = await getDurasi(
        GetOutletDurasiPerKgParams(outletId: widget.outletId, jenisLayananId: layananId),
      );

      if (mounted) {
        result.fold(
          (failure) => debugPrint('Error durasi: \${failure.message}'),
          (durasi) {
            setState(() {
              _kiloanDurations = durasi;
              kiloanDurasiNotifier.value = durasi.isNotEmpty ? durasi.first : null;
            });
          },
        );
      }
    } else {
      final getDurasiSatuan = sl<GetDurasiPerItem>();
      final result = await getDurasiSatuan(
        GetDurasiPerItemParams(outletId: widget.outletId, jenisPerItemId: layananId),
      );

      if (mounted) {
        result.fold(
          (failure) => debugPrint('Error durasi satuan: \${failure.message}'),
          (durasi) {
            setState(() {
              _satuanDurations = durasi;
              satuanDurasiNotifier.value = durasi.isNotEmpty ? durasi.first : null;
            });
          },
        );
      }
    }
  }

  Future<void> _fetchSatuanItems(String _) async {
    setState(() {
      isLoadingSatuanItems = true;
      _satuanItemsList = [];
    });
    final getItems = sl<GetOutletItemsPerItem>();
    final result = await getItems(
      widget.outletId,
    );

    if (mounted) {
      result.fold((failure) => debugPrint('Error items: ${failure.message}'), (
        items,
      ) async {
        setState(() {
          _satuanItemsList = items.where((e) => e.isActive ?? false).toList();
          isLoadingSatuanItems = false;
        });

        // Fallback: Populate _satuanServices dynamically from items if they are empty
        if (_satuanServices.isEmpty && _satuanItemsList.isNotEmpty) {
          final getJenis = sl<GetJenisByItem>();
          List<OutletLayanan> freshJenis = [];
          final Set<String> seenJenis = {};
          
          final loopLimit = _satuanItemsList.length < 5 ? _satuanItemsList.length : 5;
          for (var i = 0; i < loopLimit; i++) {
             final item = _satuanItemsList[i];
             final jRes = await getJenis(GetJenisByItemParams(outletId: widget.outletId, itemLayananId: item.id ?? ''));
             jRes.fold((_){}, (jList) {
               for (var j in jList) {
                 if (j.id != null && !seenJenis.contains(j.id)) {
                   seenJenis.add(j.id!);
                   freshJenis.add(OutletLayanan(id: j.id, nama: j.nama, tipe: 'per_item'));
                 }
               }
             });
          }
          
          if (mounted && freshJenis.isNotEmpty) {
            setState(() {
              _satuanServices = freshJenis;
              satuanLayananNotifier.value = _satuanServices.first;
              _fetchDurasi(_satuanServices.first.id ?? '', ServiceType.satuan);
            });
          }
        }
      });
    }
  }

  @override
  void dispose() {
    selectedServiceNotifier.dispose();
    selectedItemsNotifier.dispose();
    notesController.dispose();

    kiloanLayananNotifier.dispose();
    kiloanDurasiNotifier.dispose();
    kiloanParfumNotifier.dispose();

    satuanLayananNotifier.dispose();
    satuanDurasiNotifier.dispose();

    super.dispose();
  }

  void _showAddItemSheet(BuildContext context) {
    if (satuanLayananNotifier.value == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih layanan satuan terlebih dahulu')),
      );
      return;
    }

    if (isLoadingSatuanItems) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sedang memuat daftar item...')),
      );
      return;
    }

    if (_satuanItemsList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tidak ada item tersedia untuk layanan ini'),
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return _AddItemBottomSheet(
          initialItems: selectedItemsNotifier.value,
          availableItems: _satuanItemsList,
          selectedDurasiId: satuanDurasiNotifier.value?.id,
          onItemsSelected: (items) {
            selectedItemsNotifier.value = Map.from(items);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<OrderCubit>(),
      child: BlocConsumer<OrderCubit, OrderState>(
        listener: (context, state) {
          if (state is OrderCreated) {
            context.router.push(
              DropTicketRoute(
                transactionId: state.order.transactionId ?? '',
                qrCode: state.order.dropQrCode ?? '',
              ),
            );
          } else if (state is OrderError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          final isLoadingSubmit = state is OrderLoading;

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => context.router.maybePop(),
              ),
              title: const Text('Order Setup'),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Service',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ValueListenableBuilder<ServiceType>(
                      valueListenable: selectedServiceNotifier,
                      builder: (context, selectedService, child) {
                        return Row(
                          children: [
                            Expanded(
                              child: _ServiceCard(
                                title: 'Kiloan',
                                subtitle: 'Per Kilo',
                                price: 'Mulai Rp 6.000 / kg',
                                icon: Icons.scale,
                                isSelected:
                                    selectedService == ServiceType.kiloan,
                                onTap: () => selectedServiceNotifier.value =
                                    ServiceType.kiloan,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _ServiceCard(
                                title: 'Satuan',
                                subtitle: 'Per Item',
                                price: 'Mulai Rp 15k',
                                icon: Icons.checkroom,
                                isSelected:
                                    selectedService == ServiceType.satuan,
                                onTap: () => selectedServiceNotifier.value =
                                    ServiceType.satuan,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    ValueListenableBuilder<ServiceType>(
                      valueListenable: selectedServiceNotifier,
                      builder: (context, selectedService, child) {
                        if (selectedService == ServiceType.kiloan) {
                          if (isLoading)
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          return _KiloanConfigurationSection(
                            layananNotifier: kiloanLayananNotifier,
                            durasiNotifier: kiloanDurasiNotifier,
                            parfumNotifier: kiloanParfumNotifier,
                            services: _kiloanServices,
                            durations: _kiloanDurations,
                            parfums: _kiloanParfums,
                            onLayananChanged: (id) =>
                                _fetchDurasi(id, ServiceType.kiloan),
                          );
                        } else {
                          if (isLoading)
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ValueListenableBuilder<Map<String, int>>(
                                valueListenable: selectedItemsNotifier,
                                builder: (context, selectedItems, child) {
                                  return _SatuanItemsSection(
                                    selectedItems: selectedItems,
                                    availableItems: _satuanItemsList,
                                    onAddItemTap: () =>
                                        _showAddItemSheet(context),
                                    onRemoveItem: (String itemId) {
                                      final current = Map<String, int>.from(
                                        selectedItemsNotifier.value,
                                      );
                                      current.remove(itemId);
                                      selectedItemsNotifier.value = current;
                                    },
                                  );
                                },
                              ),
                              const SizedBox(height: 24),
                              _SatuanConfigurationSection(
                                layananNotifier: satuanLayananNotifier,
                                durasiNotifier: satuanDurasiNotifier,
                                services: _satuanServices,
                                durations: _satuanDurations,
                                onLayananChanged: (id) =>
                                    _fetchDurasi(id, ServiceType.satuan),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Special Notes (Optional)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.blueGrey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: TextField(
                        controller: notesController,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          hintText:
                              'e.g. Handle shoes with care, use gentle detergent for blanket...',
                          hintStyle: TextStyle(color: Colors.black54),
                          contentPadding: EdgeInsets.all(16),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.info_outline, color: Colors.blue.shade600),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Drop & Go melayani penyerahan instan. Cucian akan kami verifikasi dan tagihan akhir akan diperbarui setelah pemrosesan.',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    ValueListenableBuilder<ServiceType>(
                      valueListenable: selectedServiceNotifier,
                      builder: (context, selectedService, child) {
                        return ValueListenableBuilder<OutletLayanan?>(
                          valueListenable: kiloanLayananNotifier,
                          builder: (context, kiloanLayanan, child) {
                            return ValueListenableBuilder<OutletDurasi?>(
                              valueListenable: kiloanDurasiNotifier,
                              builder: (context, kiloanDurasi, child) {
                                return ValueListenableBuilder<OutletParfum?>(
                                  valueListenable: kiloanParfumNotifier,
                                  builder: (context, kiloanParfum, child) {
                                    return ValueListenableBuilder<
                                      OutletLayanan?
                                    >(
                                      valueListenable: satuanLayananNotifier,
                                      builder: (context, satuanLayanan, child) {
                                        return ValueListenableBuilder<
                                          OutletDurasi?
                                        >(
                                          valueListenable: satuanDurasiNotifier,
                                          builder: (context, satuanDurasi, child) {
                                            return ValueListenableBuilder<
                                              Map<String, int>
                                            >(
                                              valueListenable:
                                                  selectedItemsNotifier,
                                              builder:
                                                  (
                                                    context,
                                                    selectedItems,
                                                    child,
                                                  ) {
                                                    return _OrderSummarySection(
                                                      selectedService:
                                                          selectedService,
                                                      selectedItems:
                                                          selectedItems,
                                                      availableItems:
                                                          _satuanItemsList,
                                                      kiloanLayanan:
                                                          kiloanLayanan,
                                                      kiloanDurasi:
                                                          kiloanDurasi,
                                                      kiloanParfum:
                                                          kiloanParfum,
                                                      satuanLayanan:
                                                          satuanLayanan,
                                                      satuanDurasi:
                                                          satuanDurasi,
                                                    );
                                                  },
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoadingSubmit
                            ? null
                            : () {
                                final serviceType =
                                    selectedServiceNotifier.value;

                                if (serviceType == ServiceType.kiloan) {
                                  if (kiloanLayananNotifier.value == null ||
                                      kiloanDurasiNotifier.value == null ||
                                      kiloanParfumNotifier.value == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Mohon lengkapi konfigurasi kiloan',
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  context.read<OrderCubit>().createOrder(
                                    CreateOrderParams(
                                      outletId: widget.outletId,
                                      tipeLayanan: 'per_kg',
                                      jenisLayananId:
                                          kiloanLayananNotifier.value!.id ?? '',
                                      durasiLayananId:
                                          kiloanDurasiNotifier.value!.id ?? '',
                                      parfumId: kiloanParfumNotifier.value!.id ?? '',
                                      specialNotes: notesController.text,
                                      jenisOrder: 'drop_and_go',
                                    ),
                                  );
                                } else {
                                  if (satuanLayananNotifier.value == null ||
                                      satuanDurasiNotifier.value == null ||
                                      selectedItemsNotifier.value.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Mohon lengkapi konfigurasi satuan',
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  final items = selectedItemsNotifier
                                      .value
                                      .entries
                                      .map(
                                        (e) => CreateOrderItemParam(
                                          itemLayananId: e.key,
                                          durasiLayananId:
                                              satuanDurasiNotifier.value!.id ?? '',
                                          qty: e.value,
                                        ),
                                      )
                                      .toList();

                                  context.read<OrderCubit>().createOrder(
                                    CreateOrderParams(
                                      outletId: widget.outletId,
                                      tipeLayanan: 'per_item',
                                      jenisLayananId:
                                          satuanLayananNotifier.value!.id ?? '',
                                      parfumId: satuanParfumNotifier.value?.id,
                                      specialNotes: notesController.text,
                                      items: items,
                                      jenisOrder: 'drop_and_go',
                                    ),
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: isLoadingSubmit
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Text(
                                'Lanjutkan',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String price;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ServiceCard({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.blue.shade500 : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: isSelected
                  ? Icon(
                      Icons.check_circle,
                      color: Colors.blue.shade500,
                      size: 18,
                    )
                  : const SizedBox(height: 18),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue.shade100 : Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.blue.shade700 : Colors.grey.shade700,
                size: 28,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 11, color: Colors.black54),
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
            const SizedBox(height: 4),
            Text(
              price,
              style: TextStyle(
                fontSize: 10,
                color: Colors.blue.shade700,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}

class _SatuanItemsSection extends StatelessWidget {
  final Map<String, int> selectedItems;
  final List<OutletItem> availableItems;
  final VoidCallback onAddItemTap;
  final Function(String) onRemoveItem;

  const _SatuanItemsSection({
    required this.selectedItems,
    required this.availableItems,
    required this.onAddItemTap,
    required this.onRemoveItem,
  });

  @override
  Widget build(BuildContext context) {
    final hasItems = selectedItems.isNotEmpty;
    final totalItems = selectedItems.values.fold<int>(
      0,
      (previousValue, element) => previousValue + element,
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Selected Items',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    hasItems
                        ? 'Tap item to edit quantity'
                        : 'List items you are dropping off',
                    style: const TextStyle(color: Colors.black54, fontSize: 12),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$totalItems Items',
                  style: TextStyle(
                    color: Colors.blue.shade700,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (!hasItems)
            GestureDetector(
              onTap: onAddItemTap,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_circle_outline, color: Colors.blue.shade700),
                    const SizedBox(width: 8),
                    Text(
                      'Pilih Item Satuan',
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: onAddItemTap,
                    child: Container(
                      width: 90,
                      height: 100,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.blueGrey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Tambah Item',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ...selectedItems.entries.map((entry) {
                    final matchedItems = availableItems.where(
                      (e) => e.id == entry.key,
                    );
                    final itemDefinition = matchedItems.isNotEmpty
                        ? matchedItems.first
                        : OutletItem(
                            id: entry.key,
                            outletId: '',
                            jenisLayananId: '',
                            namaItem: 'Unknown Item',
                            isActive: true,
                            itemHarga: const [],
                          );
                    return Container(
                      width: 90,
                      height: 100,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.checkroom,
                                    color: Colors.blue,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  itemDefinition.namaItem ?? '-',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                                Text(
                                  'x${entry.value}',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () => onRemoveItem(entry.key),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              'You can also skip this and let our staff list them for you after drop-off.',
              style: TextStyle(
                color: Colors.black45,
                fontSize: 11,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

// definitions removed

class _AddItemBottomSheet extends StatefulWidget {
  final Map<String, int> initialItems;
  final List<OutletItem> availableItems;
  final String? selectedDurasiId;
  final Function(Map<String, int>) onItemsSelected;

  const _AddItemBottomSheet({
    required this.initialItems,
    required this.availableItems,
    this.selectedDurasiId,
    required this.onItemsSelected,
  });

  @override
  State<_AddItemBottomSheet> createState() => _AddItemBottomSheetState();
}

class _AddItemBottomSheetState extends State<_AddItemBottomSheet> {
  late final ValueNotifier<Map<String, int>> currentItemsNotifier;

  @override
  void initState() {
    super.initState();
    currentItemsNotifier = ValueNotifier(Map.from(widget.initialItems));
  }

  @override
  void dispose() {
    currentItemsNotifier.dispose();
    super.dispose();
  }

  void updateQuantity(String id, int delta) {
    final current = Map<String, int>.from(currentItemsNotifier.value);
    final currentQuantity = current[id] ?? 0;
    final newQuantity = currentQuantity + delta;

    if (newQuantity <= 0) {
      current.remove(id);
    } else {
      current[id] = newQuantity;
    }
    currentItemsNotifier.value = current;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 16, bottom: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pilih Item',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Tambahkan item ke dalam pesanan satuan',
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 20,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Divider(),
          ValueListenableBuilder<Map<String, int>>(
            valueListenable: currentItemsNotifier,
            builder: (context, currentItems, child) {
              return ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                itemCount: widget.availableItems.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final item = widget.availableItems[index];
                  final qty = currentItems[item.id] ?? 0;

                  int price = 0;
                  final itemHarga = item.itemHarga;
                  if (itemHarga != null && itemHarga.isNotEmpty) {
                    if (widget.selectedDurasiId != null) {
                      try {
                        price = itemHarga
                            .firstWhere(
                              (e) =>
                                  e.durasiLayananId == widget.selectedDurasiId,
                            )
                            .harga ?? 0;
                      } catch (_) {
                        price = itemHarga.first.harga ?? 0;
                      }
                    } else {
                      price = itemHarga.first.harga ?? 0;
                    }
                  }

                  return Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.checkroom, color: Colors.blue),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.namaItem ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              'Rp $price / pcs',
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => updateQuantity(item.id ?? '', -1),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.remove, size: 20),
                            ),
                          ),
                          SizedBox(
                            width: 32,
                            child: Text(
                              '$qty',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => updateQuantity(item.id ?? '', 1),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade600,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.add,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              );
            },
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  widget.onItemsSelected(currentItemsNotifier.value);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Tambahkan ke Pesanan',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderSummarySection extends StatelessWidget {
  final ServiceType selectedService;
  final Map<String, int> selectedItems;
  final List<OutletItem> availableItems;
  final OutletLayanan? kiloanLayanan;
  final OutletDurasi? kiloanDurasi;
  final OutletParfum? kiloanParfum;
  final OutletLayanan? satuanLayanan;
  final OutletDurasi? satuanDurasi;

  const _OrderSummarySection({
    required this.selectedService,
    required this.selectedItems,
    required this.availableItems,
    required this.kiloanLayanan,
    required this.kiloanDurasi,
    required this.kiloanParfum,
    required this.satuanLayanan,
    required this.satuanDurasi,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedService == ServiceType.satuan && selectedItems.isEmpty) {
      return const SizedBox.shrink();
    }

    String serviceName = '';
    String estimatedPrice = '';
    int totalItems = 0;

    if (selectedService == ServiceType.kiloan) {
      serviceName = 'Kiloan';

      if (kiloanLayanan == null || kiloanDurasi == null) {
        estimatedPrice = 'Menunggu Pilihan...';
      } else {
        int finalPrice = kiloanDurasi?.harga ?? 0;
        estimatedPrice =
            'Rp ${finalPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}/kg';
        serviceName = 'Kiloan - ${kiloanLayanan?.nama}';
      }
    } else if (selectedService == ServiceType.satuan) {
      serviceName = 'Satuan';

      if (satuanLayanan == null || satuanDurasi == null) {
        estimatedPrice = 'Menunggu Pilihan...';
      } else {
        int totalPrice = 0;
        selectedItems.forEach((id, qty) {
          try {
            final itemDef = availableItems.firstWhere((e) => e.id == id);
            int price = 0;
            final itemHarga = itemDef.itemHarga;
            if (itemHarga != null && itemHarga.isNotEmpty) {
              if (satuanDurasi != null) {
                try {
                  price = itemHarga
                      .firstWhere((e) => e.durasiLayananId == satuanDurasi!.id)
                      .harga ?? 0;
                } catch (_) {
                  price = itemHarga.first.harga ?? 0;
                }
              } else {
                price = itemHarga.first.harga ?? 0;
              }
            }
            totalPrice += (price * qty);
          } catch (_) {}
          totalItems += qty;
        });

        // Actually the API structure for Satuan is dynamic so we'd better just wait
        // until we handle the exact total price calculation correctly based on `satuanDurasi.harga`
        estimatedPrice =
            'Rp ${totalPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
        serviceName = 'Satuan - ${satuanLayanan?.nama}';
      }
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Summary',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _SummaryRow(label: 'Layanan', value: serviceName),
          if (selectedService == ServiceType.kiloan &&
              kiloanDurasi != null) ...[
            const SizedBox(height: 8),
            _SummaryRow(label: 'Durasi', value: kiloanDurasi?.nama ?? ''),
          ],
          if (selectedService == ServiceType.kiloan &&
              kiloanParfum != null) ...[
            const SizedBox(height: 8),
            _SummaryRow(label: 'Parfum', value: kiloanParfum?.nama ?? ''),
          ],
          if (selectedService == ServiceType.satuan &&
              satuanDurasi != null) ...[
            const SizedBox(height: 8),
            _SummaryRow(label: 'Durasi', value: satuanDurasi?.nama ?? ''),
          ],
          if (selectedService == ServiceType.satuan && totalItems > 0) ...[
            const SizedBox(height: 8),
            _SummaryRow(label: 'Total Item', value: '$totalItems Items'),
          ],
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Estimasi Harga',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const Text(
                    '*Menunggu Hasil Penimbangan oleh Outlet',
                    style: TextStyle(fontSize: 10),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  estimatedPrice,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.blue.shade700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _KiloanConfigurationSection extends StatelessWidget {
  final ValueNotifier<OutletLayanan?> layananNotifier;
  final ValueNotifier<OutletDurasi?> durasiNotifier;
  final ValueNotifier<OutletParfum?> parfumNotifier;
  final List<OutletLayanan> services;
  final List<OutletDurasi> durations;
  final List<OutletParfum> parfums;
  final Function(String) onLayananChanged;

  const _KiloanConfigurationSection({
    required this.layananNotifier,
    required this.durasiNotifier,
    required this.parfumNotifier,
    required this.services, 
    required this.durations,
    required this.parfums,
    required this.onLayananChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Detail Layanan',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 16),
        buildDropdownColumn<OutletLayanan>(
          label: 'Jenis Layanan',
          valueNotifier: layananNotifier,
          items: services,
          hint: 'Pilih Jenis Layanan',
          itemBuilder: (item) => item.nama ?? '',
          onChanged: (val) {
            layananNotifier.value = val;
            durasiNotifier.value = null;
            if (val != null) {
              onLayananChanged(val.id ?? '');
            }
          },
        ),
        const SizedBox(height: 16),
        ValueListenableBuilder<OutletLayanan?>(
          valueListenable: layananNotifier,
          builder: (context, layananStr, child) {
            return buildDropdownColumn<OutletDurasi>(
              label: 'Durasi',
              valueNotifier: durasiNotifier,
              items: durations,
              hint: layananStr == null
                  ? 'Pilih jenis layanan terlebih dahulu'
                  : (durations.isEmpty ? 'Memuat Durasi...' : 'Pilih Durasi'),
              // disabled: layananStr == null || durations.isEmpty,
              itemBuilder: (item) {
                return '${item.nama ?? ''} (Rp ${item.harga ?? 0}/kg)';
              },
              onChanged: (val) => durasiNotifier.value = val,
            );
          },
        ),
        const SizedBox(height: 16),
        buildDropdownColumn<OutletParfum>(
          label: 'Parfum',
          valueNotifier: parfumNotifier,
          items: parfums,
          hint: parfums.isEmpty ? 'Memuat Parfum...' : 'Pilih Parfum',
          // disabled: parfums.isEmpty,
          itemBuilder: (item) => (item.harga ?? 0) > 0
              ? '${item.nama ?? ''} (+Rp ${item.harga ?? 0}/kg)'
              : item.nama ?? '',
          onChanged: (val) => parfumNotifier.value = val,
        ),
      ],
    );
  }

  Widget buildDropdownColumn<T>({
    required String label,
    required ValueNotifier<T?> valueNotifier,
    required List<T> items,
    required String Function(T) itemBuilder,
    required void Function(T?) onChanged,
    String hint = '',
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey,
          ),
        ),
        const SizedBox(height: 8),
        ValueListenableBuilder<T?>(
          valueListenable: valueNotifier,
          builder: (context, value, child) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<T>(
                  isExpanded: true,
                  value: items.contains(value) ? value : null,
                  hint: Text(
                    hint,
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                  ),
                  items: items.map((T opt) {
                          return DropdownMenuItem<T>(
                            value: opt,
                            child: Text(
                              itemBuilder(opt),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }).toList(),
                  onChanged: onChanged,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _SatuanConfigurationSection extends StatelessWidget {
  final ValueNotifier<OutletLayanan?> layananNotifier;
  final ValueNotifier<OutletDurasi?> durasiNotifier;
  final List<OutletLayanan> services;
  final List<OutletDurasi> durations;
  final Function(String) onLayananChanged;

  const _SatuanConfigurationSection({
    required this.layananNotifier,
    required this.durasiNotifier,
    required this.services,
    required this.durations,
    required this.onLayananChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Detail Layanan',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 16),
        buildDropdownColumn<OutletLayanan>(
          label: 'Jenis Layanan',
          valueNotifier: layananNotifier,
          items: services,
          hint: 'Pilih Jenis Layanan',
          itemBuilder: (item) => item.nama ?? '',
          onChanged: (val) {
            layananNotifier.value = val;
            durasiNotifier.value = null;
            if (val != null) onLayananChanged(val.id ?? '');
          },
        ),
        const SizedBox(height: 16),
        ValueListenableBuilder<OutletLayanan?>(
          valueListenable: layananNotifier,
          builder: (context, layananStr, child) {
            return buildDropdownColumn<OutletDurasi>(
              label: 'Durasi',
              valueNotifier: durasiNotifier,
              items: durations,
              hint: layananStr == null
                  ? 'Pilih jenis sebelum durasi'
                  : (durations.isEmpty ? 'Memuat Durasi...' : 'Pilih Durasi'),
              disabled: layananStr == null || durations.isEmpty,
              itemBuilder: (item) {
                return item.nama ?? '';
              },
              onChanged: (val) => durasiNotifier.value = val,
            );
          },
        ),
      ],
    );
  }

  Widget buildDropdownColumn<T>({
    required String label,
    required ValueNotifier<T?> valueNotifier,
    required List<T> items,
    required String Function(T) itemBuilder,
    required void Function(T?) onChanged,
    String hint = '',
    bool disabled = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey,
          ),
        ),
        const SizedBox(height: 8),
        ValueListenableBuilder<T?>(
          valueListenable: valueNotifier,
          builder: (context, value, child) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: disabled ? Colors.grey.shade100 : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<T>(
                  isExpanded: true,
                  value: items.contains(value) ? value : null,
                  hint: Text(
                    hint,
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                  ),
                  items: disabled
                      ? null
                      : items.map((T opt) {
                          return DropdownMenuItem<T>(
                            value: opt,
                            child: Text(
                              itemBuilder(opt),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }).toList(),
                  onChanged: disabled ? null : onChanged,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.black54, fontSize: 13),
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
      ],
    );
  }
}
