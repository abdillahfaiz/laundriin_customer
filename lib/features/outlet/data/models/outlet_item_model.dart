import '../../domain/entities/outlet_item.dart';

class OutletItemModel extends OutletItem {
  const OutletItemModel({
    super.id,
    super.outletId,
    super.jenisLayananId,
    super.namaItem,
    super.fotoItem,
    super.isActive,
    super.itemHarga,
  });

  factory OutletItemModel.fromJson(Map<String, dynamic> json) {
    return OutletItemModel(
      id: json['id'] as String?,
      outletId: json['outlet_id'] as String?,
      jenisLayananId: json['jenis_layanan_id'] as String?,
      namaItem: json['nama_item'] as String?,
      fotoItem: json['foto_item'] as String?,
      isActive: json['is_active'] as bool?,
      itemHarga: (json['item_harga'] as List?)
          ?.map((e) => OutletItemHargaModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'outlet_id': outletId,
      'jenis_layanan_id': jenisLayananId,
      'nama_item': namaItem,
      'foto_item': fotoItem,
      'is_active': isActive,
      'item_harga': itemHarga
          ?.map((e) => (e as OutletItemHargaModel).toJson())
          .toList(),
    };
  }
}

class OutletItemHargaModel extends OutletItemHarga {
  const OutletItemHargaModel({
    super.id,
    super.itemLayananId,
    super.durasiLayananId,
    super.harga,
    super.durasiNama,
    super.estimasiJam,
  });

  factory OutletItemHargaModel.fromJson(Map<String, dynamic> json) {
    return OutletItemHargaModel(
      id: json['id'] as String?,
      itemLayananId: json['item_layanan_id'] as String?,
      durasiLayananId: json['durasi_layanan_id'] as String?,
      harga: json['harga'] != null ? int.tryParse(json['harga'].toString()) : null,
      durasiNama: json['durasi_layanan']?['nama'] as String?,
      estimasiJam: json['durasi_layanan']?['estimasi_jam'] != null
          ? int.tryParse(json['durasi_layanan']['estimasi_jam'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'item_layanan_id': itemLayananId,
      'durasi_layanan_id': durasiLayananId,
      'harga': harga,
      'durasi_layanan': {'nama': durasiNama, 'estimasi_jam': estimasiJam},
    };
  }
}
