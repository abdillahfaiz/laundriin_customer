import 'package:equatable/equatable.dart';

import '../../domain/entities/outlet.dart';
import '../../domain/entities/outlet_coverage.dart';
import '../../domain/entities/outlet_durasi.dart';
import '../../domain/entities/outlet_item.dart';
import '../../domain/entities/outlet_jenis_per_item.dart';
import '../../domain/entities/outlet_layanan.dart';
import '../../domain/entities/outlet_parfum.dart';

/// State untuk Outlet Cubit.
abstract class OutletState extends Equatable {
  const OutletState();

  @override
  List<Object?> get props => [];
}

class OutletInitial extends OutletState {
  const OutletInitial();
}

class OutletLoading extends OutletState {
  const OutletLoading();
}

/// State ketika list outlet terdekat berhasil dimuat.
class OutletListLoaded extends OutletState {
  final List<Outlet> outlets;

  const OutletListLoaded({required this.outlets});

  @override
  List<Object?> get props => [outlets];
}

/// State ketika coverage area berhasil dicek.
class OutletCoverageLoaded extends OutletState {
  final OutletCoverage coverage;

  const OutletCoverageLoaded({required this.coverage});

  @override
  List<Object?> get props => [coverage];
}

/// State ketika list layanan per-KG berhasil dimuat.
class OutletLayananLoaded extends OutletState {
  final List<OutletLayanan> layanan;

  const OutletLayananLoaded({required this.layanan});

  @override
  List<Object?> get props => [layanan];
}

/// State ketika durasi per-KG berhasil dimuat.
class OutletDurasiLoaded extends OutletState {
  final List<OutletDurasi> durasi;

  const OutletDurasiLoaded({required this.durasi});

  @override
  List<Object?> get props => [durasi];
}

/// State ketika list parfum berhasil dimuat.
class OutletParfumLoaded extends OutletState {
  final List<OutletParfum> parfum;

  const OutletParfumLoaded({required this.parfum});

  @override
  List<Object?> get props => [parfum];
}

/// State ketika items per-item berhasil dimuat.
class OutletItemsLoaded extends OutletState {
  final List<OutletItem> items;

  const OutletItemsLoaded({required this.items});

  @override
  List<Object?> get props => [items];
}

/// State ketika jenis layanan per-item berhasil dimuat.
class OutletJenisPerItemLoaded extends OutletState {
  final List<OutletJenisPerItem> jenisList;

  const OutletJenisPerItemLoaded({required this.jenisList});

  @override
  List<Object?> get props => [jenisList];
}

/// State ketika durasi per-item berhasil dimuat.
class OutletDurasiPerItemLoaded extends OutletState {
  final List<OutletDurasi> durasi;

  const OutletDurasiPerItemLoaded({required this.durasi});

  @override
  List<Object?> get props => [durasi];
}

/// State ketika terjadi error.
class OutletError extends OutletState {
  final String message;

  const OutletError({required this.message});

  @override
  List<Object?> get props => [message];
}
