import '../../domain/entities/outlet_layanan.dart';

class OutletLayananModel extends OutletLayanan {
  const OutletLayananModel({
    super.id,
    super.nama,
    super.deskripsi,
    super.tipe,
  });

  factory OutletLayananModel.fromJson(Map<String, dynamic> json) {
    return OutletLayananModel(
      id: json['id'] as String?,
      nama: json['nama'] as String?,
      deskripsi: json['deskripsi'] as String?,
      tipe: json['tipe'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nama': nama, 'deskripsi': deskripsi, 'tipe': tipe};
  }
}
