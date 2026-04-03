import '../../domain/entities/outlet_jenis_per_item.dart';

class OutletJenisPerItemModel extends OutletJenisPerItem {
  const OutletJenisPerItemModel({
    super.id,
    super.nama,
    super.deskripsi,
  });

  factory OutletJenisPerItemModel.fromJson(Map<String, dynamic> json) {
    return OutletJenisPerItemModel(
      id: json['id'] as String?,
      nama: json['nama'] as String?,
      deskripsi: json['deskripsi'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'deskripsi': deskripsi,
    };
  }
}
