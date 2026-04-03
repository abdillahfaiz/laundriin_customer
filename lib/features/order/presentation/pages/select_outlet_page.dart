import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/routes/app_router.gr.dart';
import '../../../outlet/domain/entities/outlet.dart';
import '../../../outlet/presentation/cubit/outlet_cubit.dart';
import '../../../outlet/presentation/cubit/outlet_state.dart';

@RoutePage()
class SelectOutletPage extends StatefulWidget {
  const SelectOutletPage({super.key});

  @override
  State<SelectOutletPage> createState() => _SelectOutletPageState();
}

class _SelectOutletPageState extends State<SelectOutletPage> {
  late final ValueNotifier<bool> isListViewNotifier;

  @override
  void initState() {
    super.initState();
    isListViewNotifier = ValueNotifier<bool>(true);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final position = await _determinePosition();
        if (!mounted) return;
        context.read<OutletCubit>().fetchNearbyOutlets(
          latitude: position.latitude,
          longitude: position.longitude,
        );
      } catch (e) {
        if (!mounted) return;
        context.read<OutletCubit>().fetchNearbyOutlets(
          latitude: -6.9824,
          longitude: 107.6301,
        );
      }
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  void dispose() {
    isListViewNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.router.maybePop(),
        ),
        title: const Text(
          'Pilih Outlet',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Header toggles and search
          _TopControls(isListViewNotifier: isListViewNotifier),

          // Main Content
          Expanded(
            child: ValueListenableBuilder<bool>(
              valueListenable: isListViewNotifier,
              builder: (context, isListView, child) {
                return BlocBuilder<OutletCubit, OutletState>(
                  builder: (context, state) {
                    if (state is OutletLoading || state is OutletInitial) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is OutletError) {
                      return Center(
                        child: Text(
                          state.message,
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    } else if (state is OutletListLoaded) {
                      final outlets = state.outlets;
                      if (outlets.isEmpty) {
                        return const Center(
                          child: Text('Tidak ada outlet terdekat ditemukan.'),
                        );
                      }
                      return isListView
                          ? _OutletListView(outlets: outlets)
                          : _OutletMapView(outlets: outlets);
                    }
                    return const SizedBox.shrink();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TopControls extends StatelessWidget {
  const _TopControls({required this.isListViewNotifier});

  final ValueNotifier<bool> isListViewNotifier;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      child: Column(
        children: [
          // Toggle List / Map
          Container(
            height: 44,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(22),
            ),
            child: ValueListenableBuilder<bool>(
              valueListenable: isListViewNotifier,
              builder: (context, isListView, child) {
                return Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => isListViewNotifier.value = true,
                        child: _ToggleButton(
                          isSelected: isListView,
                          icon: Icons.list,
                          label: 'List',
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => isListViewNotifier.value = false,
                        child: _ToggleButton(
                          isSelected: !isListView,
                          icon: Icons.map_outlined,
                          label: 'Map',
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          // Search Field
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: const TextField(
              decoration: InputDecoration(
                icon: Icon(Icons.search, color: Colors.black54),
                hintText: 'Cari outlet...',
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _ToggleButton extends StatelessWidget {
  const _ToggleButton({
    required this.isSelected,
    required this.icon,
    required this.label,
  });

  final bool isSelected;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(22),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.blue.shade600 : Colors.black54,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.blue.shade600 : Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _OutletListView extends StatelessWidget {
  const _OutletListView({required this.outlets});

  final List<Outlet> outlets;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        // Fallback to default coordinate if position can't be fetched quickly without complex refactor
        context.read<OutletCubit>().fetchNearbyOutlets(
          latitude: -6.9824,
          longitude: 107.6301,
        );
      },
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: outlets.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          return _OutletListItem(item: outlets[index]);
        },
      ),
    );
  }
}

class _OutletListItem extends StatelessWidget {
  const _OutletListItem({required this.item});

  final Outlet item;

  Future<String> _getDistance() async {
    final currentPosition = await Geolocator.getCurrentPosition();
    final distance = Geolocator.distanceBetween(
      currentPosition.latitude,
      currentPosition.longitude,
      item.latitude ?? 0.0,
      item.longitude ?? 0.0,
    );

    return "${(distance / 1000).toStringAsFixed(2)} km";
  }

  @override
  Widget build(BuildContext context) {
    final isOpen = item.isOpen ?? false;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.store, color: Colors.grey, size: 30),
                ),
              ),
              const SizedBox(width: 12),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            item.name ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: isOpen
                                ? Colors.green.withValues(alpha: 0.1)
                                : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            isOpen ? 'OPEN' : 'CLOSED',
                            style: TextStyle(
                              color: isOpen
                                  ? Colors.green.shade700
                                  : Colors.grey.shade600,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.address ?? '',
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.near_me,
                          size: 12,
                          color: Colors.black54,
                        ),
                        const SizedBox(width: 4),
                        FutureBuilder<String>(
                          future: _getDistance(),
                          builder: (context, snapshot) {
                            return Text(
                              snapshot.data ?? 'Menghitung...',
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 12,
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          '•',
                          style: TextStyle(color: Colors.black54),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.star, size: 14, color: Colors.orange),
                        const SizedBox(width: 4),
                        const Text(
                          '5.0',
                          style: TextStyle(color: Colors.black54, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                context.router.push(OrderSetupRoute(outletId: item.id ?? ''));
              },
              // onPressed: isOpen == true
              //     ? () {
              //         context.router.push(OrderSetupRoute(outletId: item.id ?? ''));
              //       }
              //     : null,
              // onPressed: isOpen
              //     ? () {
              //         context.router.push(OrderSetupRoute(outletId: item.id));
              //       }
              //     : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isOpen
                    ? Colors.blue.shade600
                    : Colors.grey.shade100,
                foregroundColor: isOpen ? Colors.white : Colors.grey.shade400,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(isOpen ? 'Pilih' : 'Tutup'),
            ),
          ),
        ],
      ),
    );
  }
}

class _OutletMapView extends StatefulWidget {
  const _OutletMapView({required this.outlets});

  final List<Outlet> outlets;

  @override
  State<_OutletMapView> createState() => _OutletMapViewState();
}

class _OutletMapViewState extends State<_OutletMapView> {
  GoogleMapController? _mapController;
  late final ValueNotifier<Outlet?> selectedOutletNotifier;
  late final Future<Position> _locationFuture;

  @override
  void initState() {
    super.initState();
    selectedOutletNotifier = ValueNotifier<Outlet?>(
      widget.outlets.isNotEmpty ? widget.outlets.first : null,
    );
    _locationFuture = _determinePosition();
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Default location if services are disabled
      return Position(
        longitude: 106.8400,
        latitude: -6.2200,
        timestamp: DateTime.now(),
        accuracy: 0.0,
        altitude: 0.0,
        altitudeAccuracy: 0.0,
        heading: 0.0,
        headingAccuracy: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
      );
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Position(
          longitude: 106.8400,
          latitude: -6.2200,
          timestamp: DateTime.now(),
          accuracy: 0.0,
          altitude: 0.0,
          altitudeAccuracy: 0.0,
          heading: 0.0,
          headingAccuracy: 0.0,
          speed: 0.0,
          speedAccuracy: 0.0,
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Position(
        longitude: 106.8400,
        latitude: -6.2200,
        timestamp: DateTime.now(),
        accuracy: 0.0,
        altitude: 0.0,
        altitudeAccuracy: 0.0,
        heading: 0.0,
        headingAccuracy: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
      );
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    selectedOutletNotifier.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ValueListenableBuilder<Outlet?>(
          valueListenable: selectedOutletNotifier,
          builder: (context, selectedOutlet, child) {
            Set<Marker> markers = widget.outlets.map((item) {
              final isSelected = selectedOutlet?.id == item.id;
              return Marker(
                markerId: MarkerId(item.id ?? ''),
                position: LatLng(item.latitude ?? 0.0, item.longitude ?? 0.0),
                icon: isSelected
                    ? BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueBlue,
                      )
                    : BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueRed,
                      ),
                onTap: () {
                  selectedOutletNotifier.value = item;
                  _mapController?.animateCamera(
                    CameraUpdate.newLatLngZoom(
                      LatLng(item.latitude ?? 0.0, item.longitude ?? 0.0),
                      14.0,
                    ),
                  );
                },
              );
            }).toSet();

            return FutureBuilder<Position>(
              future: _locationFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final currentLatLng = snapshot.hasData
                    ? LatLng(snapshot.data!.latitude, snapshot.data!.longitude)
                    : const LatLng(-6.2200, 106.8400);

                return GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: widget.outlets.isNotEmpty
                        ? LatLng(
                            widget.outlets.first.latitude ?? 0.0,
                            widget.outlets.first.longitude ?? 0.0,
                          )
                        : currentLatLng,
                    zoom: 13.0,
                  ),
                  markers: markers,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: false,
                );
              },
            );
          },
        ),

        // Detail Card (if selected)
        ValueListenableBuilder<Outlet?>(
          valueListenable: selectedOutletNotifier,
          builder: (context, selectedOutlet, child) {
            if (selectedOutlet == null) return const SizedBox.shrink();
            return Positioned(
              bottom: 24,
              left: 16,
              right: 16,
              child: _OutletMapDetailCard(item: selectedOutlet),
            );
          },
        ),

        // Zoom/Location Controls
        Positioned(
          top: 16,
          right: 16,
          child: Column(
            children: [
              _MapControlButton(
                icon: Icons.my_location,
                onTap: () async {
                  final position = await Geolocator.getCurrentPosition();
                  _mapController?.animateCamera(
                    CameraUpdate.newLatLngZoom(
                      LatLng(position.latitude, position.longitude),
                      14.0,
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
              _MapControlButton(
                icon: Icons.add,
                onTap: () {
                  _mapController?.animateCamera(CameraUpdate.zoomIn());
                },
              ),
              Container(height: 1, width: 40, color: Colors.grey.shade200),
              _MapControlButton(
                icon: Icons.remove,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
                onTap: () {
                  _mapController?.animateCamera(CameraUpdate.zoomOut());
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MapControlButton extends StatelessWidget {
  const _MapControlButton({
    required this.icon,
    required this.onTap,
    this.borderRadius,
  });

  final IconData icon;
  final VoidCallback onTap;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius ?? BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.black87),
      ),
    );
  }
}

class _OutletMapDetailCard extends StatelessWidget {
  const _OutletMapDetailCard({required this.item});

  final Outlet item;

  @override
  Widget build(BuildContext context) {
    final isOpen = item.isOpen ?? false;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Placeholder Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 70,
                  height: 70,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.store, color: Colors.grey, size: 36),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            item.name ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.orange,
                                size: 12,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '5.0',
                                style: TextStyle(
                                  color: Colors.orange.shade800,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 12,
                          color: Colors.black54,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${item.distanceKm ?? 0} km away',
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isOpen
                                ? Colors.green.shade50
                                : Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            isOpen ? 'Open Now' : 'Closed',
                            style: TextStyle(
                              color: isOpen
                                  ? Colors.green.shade700
                                  : Colors.red.shade700,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
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
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isOpen
                  ? () {
                      context.router.push(OrderSetupRoute(outletId: item.id ?? ''));
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isOpen
                    ? Colors.blue.shade600
                    : Colors.grey.shade200,
                foregroundColor: isOpen ? Colors.white : Colors.grey.shade500,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Pilih Outlet',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
