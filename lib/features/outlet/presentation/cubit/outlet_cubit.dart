import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/check_coverage_area.dart';
import '../../domain/usecases/get_durasi_per_item.dart';
import '../../domain/usecases/get_jenis_by_item.dart';
import '../../domain/usecases/get_nearby_outlets.dart';
import '../../domain/usecases/get_outlet_durasi.dart';
import '../../domain/usecases/get_outlet_items.dart';
import '../../domain/usecases/get_outlet_layanan.dart';
import '../../domain/usecases/get_outlet_parfum.dart';
import 'outlet_state.dart';

/// Cubit untuk mengelola state outlet.
class OutletCubit extends Cubit<OutletState> {
  final GetNearbyOutlets getNearbyOutletsUseCase;
  final CheckCoverageArea checkCoverageAreaUseCase;
  final GetOutletLayananPerKg getOutletLayananPerKgUseCase;
  final GetOutletDurasiPerKg getOutletDurasiPerKgUseCase;
  final GetOutletParfum getOutletParfumUseCase;
  final GetOutletItemsPerItem getOutletItemsPerItemUseCase;
  final GetJenisByItem getJenisByItemUseCase;
  final GetDurasiPerItem getDurasiPerItemUseCase;

  OutletCubit({
    required this.getNearbyOutletsUseCase,
    required this.checkCoverageAreaUseCase,
    required this.getOutletLayananPerKgUseCase,
    required this.getOutletDurasiPerKgUseCase,
    required this.getOutletParfumUseCase,
    required this.getOutletItemsPerItemUseCase,
    required this.getJenisByItemUseCase,
    required this.getDurasiPerItemUseCase,
  }) : super(const OutletInitial());

  /// Mendapatkan outlet terdekat.
  Future<void> fetchNearbyOutlets({
    required double latitude,
    required double longitude,
    double? radius,
    int? page,
    int? limit,
  }) async {
    emit(const OutletLoading());

    final result = await getNearbyOutletsUseCase(
      NearbyOutletsParams(
        latitude: latitude,
        longitude: longitude,
        radius: radius,
        page: page,
        limit: limit,
      ),
    );

    result.fold(
      (failure) => emit(OutletError(message: failure.message)),
      (outlets) => emit(OutletListLoaded(outlets: outlets)),
    );
  }

  /// Mengecek apakah lokasi customer masuk area cakupan outlet.
  Future<void> checkCoverage({
    required String outletId,
    required double latitude,
    required double longitude,
  }) async {
    emit(const OutletLoading());

    final result = await checkCoverageAreaUseCase(
      CheckCoverageAreaParams(
        outletId: outletId,
        latitude: latitude,
        longitude: longitude,
      ),
    );

    result.fold(
      (failure) => emit(OutletError(message: failure.message)),
      (coverage) => emit(OutletCoverageLoaded(coverage: coverage)),
    );
  }

  /// Mendapatkan list layanan per-KG dari outlet.
  Future<void> fetchOutletLayananPerKg(String outletId) async {
    emit(const OutletLoading());
    final result = await getOutletLayananPerKgUseCase(outletId);
    result.fold(
      (failure) => emit(OutletError(message: failure.message)),
      (layanan) => emit(OutletLayananLoaded(layanan: layanan)),
    );
  }

  /// Mendapatkan durasi per-KG berdasarkan jenis layanan.
  Future<void> fetchOutletDurasiPerKg(
    String outletId,
    String jenisLayananId,
  ) async {
    emit(const OutletLoading());
    final result = await getOutletDurasiPerKgUseCase(
      GetOutletDurasiPerKgParams(
        outletId: outletId,
        jenisLayananId: jenisLayananId,
      ),
    );
    result.fold(
      (failure) => emit(OutletError(message: failure.message)),
      (durasi) => emit(OutletDurasiLoaded(durasi: durasi)),
    );
  }

  /// Mendapatkan list parfum untuk outlet yang dipilih.
  Future<void> fetchOutletParfum(String outletId) async {
    emit(const OutletLoading());
    final result = await getOutletParfumUseCase(outletId);
    result.fold(
      (failure) => emit(OutletError(message: failure.message)),
      (parfum) => emit(OutletParfumLoaded(parfum: parfum)),
    );
  }

  /// Mendapatkan item layanan per-item dari outlet.
  Future<void> fetchOutletItemsPerItem(String outletId) async {
    emit(const OutletLoading());
    final result = await getOutletItemsPerItemUseCase(outletId);
    result.fold(
      (failure) => emit(OutletError(message: failure.message)),
      (items) => emit(OutletItemsLoaded(items: items)),
    );
  }

  /// Mendapatkan jenis layanan berdasarkan item.
  Future<void> fetchJenisByItem(
    String outletId,
    String itemLayananId,
  ) async {
    emit(const OutletLoading());
    final result = await getJenisByItemUseCase(
      GetJenisByItemParams(
        outletId: outletId,
        itemLayananId: itemLayananId,
      ),
    );
    result.fold(
      (failure) => emit(OutletError(message: failure.message)),
      (jenisList) => emit(OutletJenisPerItemLoaded(jenisList: jenisList)),
    );
  }

  /// Mendapatkan durasi per-item berdasarkan jenis.
  Future<void> fetchDurasiPerItem(
    String outletId,
    String jenisPerItemId,
  ) async {
    emit(const OutletLoading());
    final result = await getDurasiPerItemUseCase(
      GetDurasiPerItemParams(
        outletId: outletId,
        jenisPerItemId: jenisPerItemId,
      ),
    );
    result.fold(
      (failure) => emit(OutletError(message: failure.message)),
      (durasi) => emit(OutletDurasiPerItemLoaded(durasi: durasi)),
    );
  }
}
