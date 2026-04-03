import 'package:equatable/equatable.dart';

class OutletItem extends Equatable {
  final String? id;
  final String? outletId;
  final String? jenisLayananId;
  final String? namaItem;
  final String? fotoItem;
  final bool? isActive;
  final List<OutletItemHarga>? itemHarga;

  const OutletItem({
    this.id,
    this.outletId,
    this.jenisLayananId,
    this.namaItem,
    this.fotoItem,
    this.isActive,
    this.itemHarga,
  });

  @override
  List<Object?> get props => [
    id,
    outletId,
    jenisLayananId,
    namaItem,
    fotoItem,
    isActive,
    itemHarga,
  ];
}

class OutletItemHarga extends Equatable {
  final String? id;
  final String? itemLayananId;
  final String? durasiLayananId;
  final int? harga;
  final String? durasiNama;
  final int? estimasiJam;

  const OutletItemHarga({
    this.id,
    this.itemLayananId,
    this.durasiLayananId,
    this.harga,
    this.durasiNama,
    this.estimasiJam,
  });

  @override
  List<Object?> get props => [
    id,
    itemLayananId,
    durasiLayananId,
    harga,
    durasiNama,
    estimasiJam,
  ];
}
